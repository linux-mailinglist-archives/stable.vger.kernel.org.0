Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9B2100D02
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 21:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfKRUXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 15:23:11 -0500
Received: from mail-oi1-f169.google.com ([209.85.167.169]:38702 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfKRUXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 15:23:11 -0500
Received: by mail-oi1-f169.google.com with SMTP id a14so16588959oid.5
        for <stable@vger.kernel.org>; Mon, 18 Nov 2019 12:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OAyuhc8eTPHZStGj4j04Bunphq3hKbWOo/Q7FfcBi2k=;
        b=O6pfFYaHCzZMMJh/xfB2Gdzcmc/whitIceAHDfkDZbHkDnVEzPioXK2EiS3eT9srVm
         pSIbM66Kc/vhV2S8gvmD44SG9hVgyJqXNcZo3giZmAmp8rQG+32/bMgcd3kubkOrJuyy
         cyQuKXJC0F6kOtHJq6rzyLfDLigYDMiMu3bJUVtHXmVWLqmNayrh0Ull9CRldm281pz2
         zqf9Nu79u0G9X3CEYF3Re4X7DbLlIJ95wg11I0Z06ou+0SpvDs7QCTzgzfhkTnv4AdJL
         enwo9Tl2XMD4QFaQsWS6fKD7sMiEDfNCwrVwYy8Au7kSECSiEkRNhe0XICg/jN//PNsv
         M2bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OAyuhc8eTPHZStGj4j04Bunphq3hKbWOo/Q7FfcBi2k=;
        b=kfc00jRygl3gSNADPnoSocCdmpWuAatk/4r6+MQHXNG4aJBUAycp60KDx1JiIIs6zj
         ywSMYpZFQ1xjQKYJEI/po4w/qnbXPkNbtglD2hNzds8X6jdYRFITgZiwliK7b2hfiFAd
         Za01k+z6qVdBkkGW6qtPr96xl+5uROjurcce24/oY3D/vB4f065xPTpU4ChTZ8T1DWID
         0rQ4/y4yz/OsurytwEWNOIKQdXUxb+FSYfp+Uv70hlzQAjD+m12UovLHWb/o30PLeWx9
         CAg/IYIJX8aNVYzZa+9OKlTd40YRxRUNytLNUntMvTAlFXs/PvOrMDaxqL5J3QDoZwfV
         JhXw==
X-Gm-Message-State: APjAAAXRQ/gQsabrIHtfwPXuXJVCee0ogavyw7Op4jqFOSE4A9v5Dg2R
        wpgNeDXCZ3kfNcunQ0ADV5in3CpcWqEa/PWDdnM=
X-Google-Smtp-Source: APXvYqxozPWBKisfxR4/iqDUX7IDMrfFvBHCof/BiYVSqPV+pQksS+VrG43/KLF09jwUHe+OjZKRI2JwcqcRYaQ10fw=
X-Received: by 2002:aca:d0d:: with SMTP id 13mr763113oin.44.1574108590290;
 Mon, 18 Nov 2019 12:23:10 -0800 (PST)
MIME-Version: 1.0
References: <95023b9f-1281-b74b-cae0-0516ee4ceb90@gmail.com>
In-Reply-To: <95023b9f-1281-b74b-cae0-0516ee4ceb90@gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 18 Nov 2019 20:22:34 +0000
Message-ID: <CADVatmObLQ9-aPN1s9qLNh0JVO08fxJ_r_YGvuGqyF4Lsf9KeQ@mail.gmail.com>
Subject: Re: Size of the stable-queue git tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>,
        =?UTF-8?Q?Fran=C3=A7ois_Valenduc?= <francoisvalenduc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 6:55 PM Fran=C3=A7ois Valenduc
<francoisvalenduc@gmail.com> wrote:
>
> Hello everybody,
>
> I pulled the stable-queue tree just now. This was not an inital clone,
> but only an update. My previous update was end of last week I was
> surprised I had to download 1,19 Gb to download.

same for me too. 1.2GiB.


--=20
Regards
Sudip
