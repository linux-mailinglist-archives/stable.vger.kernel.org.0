Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66626609831
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 04:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiJXCZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 22:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJXCZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Oct 2022 22:25:15 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B407437429
        for <stable@vger.kernel.org>; Sun, 23 Oct 2022 19:25:11 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g28so7876919pfk.8
        for <stable@vger.kernel.org>; Sun, 23 Oct 2022 19:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kWmzWfMlTanX/RCLrdSL+lExsTd/mFjS+aAmguk9vrk=;
        b=L6jcbJBwqi7C8lakQ51WrWDloCaubxunaMYygliIPZP/iPFzPtvdTPJsDERjKI/VIF
         yxmMiILSTqGoSOWfam+V671EAIL6xc9ytfQYJBg7KRemmRyReo2a/Xu2QYPKN1zlGKSB
         /z0ip3IT+3hRyK/iyxfqc30MGgaOqWQbK1M5FdccMkgXZyHXoV7U29R7UziiYO6CDg7Y
         NpUJRaccrQnDLZQRUUcTSKC17NrEl1A5mP9t5FYrdIyZzRkNTxLnp7IwWl98IZwOsDAL
         GvXu4vtcELxU38S0hQiaH4GDYiG+JLLvvILXtZAVCHcnztCIAtBJbDXhM3xXleQSQI9+
         DK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kWmzWfMlTanX/RCLrdSL+lExsTd/mFjS+aAmguk9vrk=;
        b=I29xgftLQbnPmGI3gHqXQuX47BmlUXODRqlAfQ7frhk5E0HX1YJyjIQrgScRZyvhCU
         /Tis0TrvoFfRurJwhaqDO6GhrM6Ob4U/y+wJetJikyElV4F1o8SSj4YEQdVkOGnbk+M+
         bL6cXkOWdfG9bUGBGkgV08sOdeyHY3+FcGFaBBmkx+UqLpK+7JLkc1ynn//TP+Sur8Xw
         RG8aXax3KoP0RzoJAVPQZRRszEia9ScpB9hUxqxUkz3nUHksmhptCwz2pCNd9Jqo826P
         SdnOQ+am4ZCLKLGj/fW7P291thU/emK1Hj2tDcB6g2ioFHWw0igVz26z/5RhbzWvPGwE
         OM1g==
X-Gm-Message-State: ACrzQf3zYMzk50k/73YQdFr3jliL0IQGRceY+dbAku/rutyX8OI4TnKj
        JDq8ZuWyIJTRgLc13hIq+CepBtWyTgA=
X-Google-Smtp-Source: AMsMyM58JmW6F5JkItqXbiEz8OiXgqRuMMpg4l66Gr4HqgWFRZaPS2J5vucpJA5u7V1pTG4CawLMHA==
X-Received: by 2002:a63:1d5a:0:b0:46e:d157:39ef with SMTP id d26-20020a631d5a000000b0046ed15739efmr10021456pgm.231.1666578310657;
        Sun, 23 Oct 2022 19:25:10 -0700 (PDT)
Received: from [192.168.50.208] (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id t4-20020a655544000000b00464858cf6b0sm16677802pgr.54.2022.10.23.19.25.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Oct 2022 19:25:09 -0700 (PDT)
Message-ID: <cdc7d1cf-3ad2-c2d2-8006-22bf51f8df4a@gmail.com>
Date:   Sun, 23 Oct 2022 19:25:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Justin Tee <justintee8345@gmail.com>
From:   James Smart <jsmart2021@gmail.com>
Subject: LTS 5.15 and state of lpfc
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg, Sasha,

We were notified of an lpfc issue in the LTS 5.15 kernel. Its a pretty 
fundamental error that keeps us from connecting to the FC switch.

In the past several kernel releases, we have been reworking areas of the 
driver to fix issues in the broader design rather than continuing to 
create a patchwork on an issue-by-issue basis. This means there are a 
lot of inter-related patches.

In this case, it appears that a portion of the "path split" rework was 
pulled into 5.15, and the portion that wasn't picked up introduced the 
error.

I had Justin look at simply reverting patches, which wasn't too bad, but 
we have identified an issue in the result. The fix, of course, is 
embedded into the "path split" patches.

I don't think we want to create one-off patches that won't move forward, 
so I had him look at rolling forward to pick up all the "path split" 
patches. This looks like a fairly viable alternative.  The steps are 
listed below. This brings it up to a point that is pretty close to the 
content in 5.18.y

How do we best resolve this in the 5.15 LTS tree ?

-- james



Here are the steps to roll-forward:


1.) git remote add -t 6.1/scsi-staging mkp-scsi 
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
2.) git fetch mkp-scsi
3.) git rebase -i 1c5e670d6a5a~

4.) Remove the following commits:
1c5e670d6a5a scsi: lpfc: SLI path split: Refactor lpfc_iocbq
c56cc7fefc31 scsi: lpfc: SLI path split: Refactor fast and slow paths to 
native SLI4
b4543dbea84c scsi: lpfc: SLI path split: Refactor SCSI paths
2b5ef6430c21 scsi: lpfc: Remove extra atomic_inc on cmd_pending in 
queuecommand after VMID
9a570069cdbb scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()
6e99860de6f4 scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()
17bf429b913b scsi: lpfc: Resolve some cleanup issues following SLI path 
refactoring

Rebase is expected to be clean after removal of mentioned patches.

5.) Cherry-pick SLI path split patches from mkp-scsi:
git cherry-pick a680a9298e7b 1b64aa9eae28 561341425bcc 6831ce129f19 
cad93a089031 3bea83b68d54 3f607dcb43f1 e0367dfe90d6 9d41f08aa2eb 
351849800157 2d1928c57df6 61910d6a5243 3512ac094293 31a59f75702f 
0e082d926f59

6.) Cherry-pick the atomic_inc VMID fix:
git cherry-pick 0948a9c53860

7.) Cherry-pick all known SLI path split fixes:
git cherry-pick 7294a9bcaa7e c26bd6602e1d c2024e3b33ee cc28fac16ab7 
775266207105 84c6f99e3907 596fc8adb171 44ba9786b673 24e1f056677e 
e27f05147bff

All the cherry-picks are expected to apply cleanly.
