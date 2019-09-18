Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44225B69BD
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 19:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbfIRRkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 13:40:37 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:39871 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbfIRRkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 13:40:37 -0400
Received: by mail-pl1-f170.google.com with SMTP id x6so293218plv.6;
        Wed, 18 Sep 2019 10:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:to:from:subject:openpgp:autocrypt:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=plQppAZKxNCPpfK0Y6vuJ/Qx4m3hZLsL5u1XGwlg8f0=;
        b=bV4R1sZPwPZWMk6wZJLR1ULxsXXuQHiVMPNHOKYUoajXTpS2mZIxOf0siUyoReIq6x
         gU/5M5N1GPqZa+YnSwUWLaKALfe28Vwt/m8ylDZubL3QPZ1/BCP0NMj+1B89L6bbeFuo
         Kw2xO/6f+04feEL5b/cygXPqe8JJL7Cdrx8a5OSduHiQT/KiFvtKeZwSwel+Ohq1UqZ1
         HUbZVDRuyVVRmQVVh69F1437fiZhy1klWXOA1R3VY13RXkT6iI4dXuaYTi5tg6C29Sgy
         I7FvCRK3TUOHrU+i5zlr9tA4MpZ33Tyecf76NHD7RBCJaaEUkKmftWdrOsInGwEvBFEQ
         +dFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:to:from:subject:openpgp:autocrypt:message-id
         :date:user-agent:mime-version:content-transfer-encoding
         :content-language;
        bh=plQppAZKxNCPpfK0Y6vuJ/Qx4m3hZLsL5u1XGwlg8f0=;
        b=UhdGGeJetVnRDVo2FBB+BRNM008kswy80iMPmLTo1ei/AJ+KAKIC0C+jbb+AzU7qLU
         qy9Bpy+uZq3J/eXtwT9d9zGd0mIJysM8ZuP2oOuqRLeRtuQUzKvxke5ZF932GAq1cSGb
         JKvruQETZ3Mcq2s/Am5NcW9uQSvvB2Qvu1Ahqcr96BXQRlUk8ZDTGMh+moFWAZKPdCpH
         cQ7icHvW3n36oWux4VQstoSInXrFbAYZuOIqc+VhFu9q9216spyJ3CrLoUSJ3hdVB77z
         cQSnEaU07d3sqLesC+1gM5nsbKYDTCqw+rYINZhBxOj6WK/cZ80JrKsNlWIDcsxktvGm
         uBkQ==
X-Gm-Message-State: APjAAAXKoj+ihX1yC0HA2cgfpvSp/RlcJFGnMRukm2muNca4elBrd3th
        3ySGmyP3kXZ5JfNmf8yAZ30qa4qdD+wVrQ==
X-Google-Smtp-Source: APXvYqxw59ckELdZO06d3bXQlyPV8qFVJ6Xn8dLYmiumsySBr0RnFNU4CPTEwaSXEUdUcA0hR7WD1w==
X-Received: by 2002:a17:902:76c9:: with SMTP id j9mr5186588plt.187.1568828434734;
        Wed, 18 Sep 2019 10:40:34 -0700 (PDT)
Received: from [192.168.111.105] ([198.182.47.47])
        by smtp.gmail.com with ESMTPSA id w65sm8756823pfb.106.2019.09.18.10.40.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 10:40:33 -0700 (PDT)
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kbuild test robot <lkp@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        arcml <linux-snps-arc@lists.infradead.org>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Vineet Gupta <vineetg76@gmail.com>
Subject: stable backport for dc8635b78cd8669
Openpgp: preference=signencrypt
Autocrypt: addr=vineetg76@gmail.com; prefer-encrypt=mutual; keydata=
 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
 deE0Dvw98SWmZSNtdOPnJZ0D
Message-ID: <efb68643-3750-e94b-8387-6e4cacb3a82a@gmail.com>
Date:   Wed, 18 Sep 2019 10:40:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Stable team,

Can we please backport dc8635b78cd8669c37e230058d18c33af7451ab1 ("kernel/exit.c:
export abort() to modules")

0-Day kernel test infra reports ARC 4.x.y builds failing after backport of
af1be2e21203867cb958aace ("ARC: handle gcc generated __builtin_trap for older
compiler")

Thx
-Vineet
