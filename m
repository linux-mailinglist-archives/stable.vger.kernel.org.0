Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA85139ABC
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 21:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgAMUaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 15:30:16 -0500
Received: from mail-ed1-f53.google.com ([209.85.208.53]:33982 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgAMUaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 15:30:16 -0500
Received: by mail-ed1-f53.google.com with SMTP id l8so9778444edw.1;
        Mon, 13 Jan 2020 12:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=y4sfoniwMt9T4FiSeYM4bsL8cfJwjPsCGqccD51JtpA=;
        b=nL46GAVtjSmtZ8xePpnFZINToDH3tlVTOwHkrcGWgriTapFPkhnQMabvHVXJcu4/i+
         chH95kEmxhKOfaOk0IGYO/YCLAIND8B/PnNg/N5NIHCFYE8oRvan1DTXcyv7pHoVWbMt
         JnG04h9ZWrjms73Mx+qj2OqlteR39jku+QyJ9XlyAHLTxAYxuwF07ebIb1fWvCadgcLt
         PcKDndpdg0xPyhmGI5GhSlPHwpVBmwElJfFr34byiLrv5aOMMyurpzNkxuNQK6OsaZ6O
         OGdQZrec+OJFUdKw7iTrOHrW32AgEfOrSECccPhEzgZFfsy3dm6u8N07J2FlmG11i5ba
         frfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=y4sfoniwMt9T4FiSeYM4bsL8cfJwjPsCGqccD51JtpA=;
        b=OKv7ghtIAZikVVvF/6KZc1Te1WC2Yz2kkSL9FXADeFVrJAhsQhOtLSdNnlwK6H1DfM
         6ldTeIRSf6uX4nvgZgL6rZEzhgYg1V7Jkvoe5rz8MwT19LVNlkRmJO3PXHhamggLi9B4
         5sWdahlIGtEvqUM4uB8NPPJvYVWEGMiDlI07VdDY7fA59BAFRQdh+ICybKGFRa32tSxW
         6MJI4LJcooyAmtT+a/WLFsfMMlzlwnwLizCRoaxpkyjaRwLbzfWDNYeFFP/53EYNbrEz
         XyadUnEka11VHNKmTdF8aZj/Pdk9gkm9wsO56y70bPTBzz68dODR4JoGrMiiTVUjlydW
         rPdA==
X-Gm-Message-State: APjAAAVtdCePZ1lmEifA9iBrv7iJQhT+ojnTe0tj/NafEO4800M0aV52
        R/xDznFrdpl5VeG/RDcp0Ohs13K34a3VDP4gTG8=
X-Google-Smtp-Source: APXvYqz9/JaxDYLS7qf9ai/vBBO77c5WjJfn1LFXo5DOAhceZ8y1KH6605evQXQgZCq8BjUSknUEMAmHEEL95mYNIBs=
X-Received: by 2002:a50:d69a:: with SMTP id r26mr19358575edi.148.1578947414160;
 Mon, 13 Jan 2020 12:30:14 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6402:1c11:0:0:0:0 with HTTP; Mon, 13 Jan 2020 12:30:13
 -0800 (PST)
In-Reply-To: <20200113200832.GR13310@zn.tnic>
References: <CACMCwJK-2DHZDA_F5Z3wsEUEKJSc3uOwwPD4HRoYGW7A+kA75w@mail.gmail.com>
 <20200113154739.GB11244@42.do-not-panic.com> <CACMCwJL8tu+GHPeRADR_12xhcYSiDv+Yxdy=yLqMxEsn=P9zFA@mail.gmail.com>
 <20200113200832.GR13310@zn.tnic>
From:   Jari Ruusu <jari.ruusu@gmail.com>
Date:   Mon, 13 Jan 2020 22:30:13 +0200
Message-ID: <CACMCwJLsj6D884Sxy82VbpKkip=ja2ymHKvQ78c=-ftx-zmV_Q@mail.gmail.com>
Subject: Re: Fix built-in early-load Intel microcode alignment
To:     Borislav Petkov <bp@alien8.de>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        johannes.berg@intel.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/13/20, Borislav Petkov <bp@alien8.de> wrote:
> Btw, just out of curiosity: why are you using built-in microcode and not
> the initrd method?

Initrd method is better when it is a kernel intended to be booted
on many different computers. Built-in microcode method kernel is
tuned for one computer only. It is less hassle that way.

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
