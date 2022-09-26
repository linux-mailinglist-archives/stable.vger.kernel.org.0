Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D565EA9CB
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 17:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbiIZPLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 11:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235792AbiIZPK4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 11:10:56 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7995FEA5AC;
        Mon, 26 Sep 2022 06:46:15 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 129so5165419pgc.5;
        Mon, 26 Sep 2022 06:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=l3cL4GnTpBaqAQzOHxlXz68xL62a5Wx/q/VSUZdMGZE=;
        b=YdF7Udg+47ErUR9qm3323kY6wfee3S/sFaHPi066Wip6PJhwuaYP+N68/ZAmMJMTno
         DgD26FFG+WhGnKgRE7DWsCR5kJS+aXG3TFNN5pW243Hk2T454QB+3eYc8q0+sZ+rQdk4
         hIKIH84Cb/V/vg5gfVDV8Z6slfm5pt6atSXbcU4rKuiiaxIq5m03rDueveyvrPkIWutW
         qavWmtq002iCM/a7i6x6fgznNhmXWkNqWPkCJorTdTIxK1XzVungmn3sYlK6+QBTRJLC
         w7UyHyhK/JnmzOebfg4PP3EqFuVaCOKD6kLePKBENC4HEGK3UlkaY4l+5ZDSJa0Rpsl9
         nR5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=l3cL4GnTpBaqAQzOHxlXz68xL62a5Wx/q/VSUZdMGZE=;
        b=Dhp9SJzztUAK/nHfsq1su/nFHBMF615iLa+GngP5wGwk1lsboNpTN50TvFSRFsE9RD
         qANEFEb4lDPkXCCRo0RxhhmRXBZgYDUJOC+7p2QHNXsSR4a7PCEH9ckPvNWFjAI6KOoA
         AEjkwTyzeaDuhk22IzT1X9lgF/+AdewMkWFR1jDveRkaVijAGqtLTtcGzVX9CBmXijBp
         MUrgV1ul0KAj0YvrkG8ihe3dILJaOHo0cgWay/gYU7rIOLbh39gDxX/2S2RAL43JKHdx
         +7mgI25VytbDrwDUfwzJlqtE9xJdogsdX2ybhjgllfL2EdRGPjW1Bx6mrG43BjynWicV
         S7sA==
X-Gm-Message-State: ACrzQf1ZAaR60Lw/X1nAcwdx8bap0ompFZh/U+FMyOM+2qowdsuYVi3B
        QGpRera6npTpyuBXIfmgwp8=
X-Google-Smtp-Source: AMsMyM73ZoCbzWh3bzgXttSfUuiIKycBauhMEncTXirv/acGtlHry0nQwWk1zmx9v5yW0RcmHJQBgQ==
X-Received: by 2002:a05:6a00:2185:b0:520:7276:6570 with SMTP id h5-20020a056a00218500b0052072766570mr23775324pfi.84.1664199974951;
        Mon, 26 Sep 2022 06:46:14 -0700 (PDT)
Received: from [192.168.43.80] (subs28-116-206-12-41.three.co.id. [116.206.12.41])
        by smtp.gmail.com with ESMTPSA id i2-20020a17090332c200b0015e8d4eb26esm11217393plr.184.2022.09.26.06.46.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 06:46:14 -0700 (PDT)
Message-ID: <ca8efe3b-1aeb-8a4e-79e9-3f3f9281ff34@gmail.com>
Date:   Mon, 26 Sep 2022 20:46:09 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH 4.9 04/30] video: fbdev: skeletonfb: Fix syntax errors in
 comments
Content-Language: en-US
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiang wangx <wangxiang@cdjrlc.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
References: <20220926100736.153157100@linuxfoundation.org>
 <20220926100736.313886468@linuxfoundation.org> <20220926102801.GA8978@amd>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220926102801.GA8978@amd>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/26/22 17:28, Pavel Machek wrote:
> On Mon 2022-09-26 12:11:35, Greg Kroah-Hartman wrote:
>> From: Xiang wangx <wangxiang@cdjrlc.com>
>>
>> [ Upstream commit fc378794a2f7a19cf26010dc33b89ba608d4c70f ]
>>
>> Delete the redundant word 'its'.
> 
> This does not belong in stable.
> 

Without seeing the upstream commit, the patch subject is misleading:
the patch doesn't fix any syntax errors as one might get from the
compiler.

Also, what I find irritating is that I have never seen reply from
@cdjrlc.com people to review comments pointing flaws of their patch.
I guess they don't have any other jobs here in LKML other than just
throwing one-line redundant word stripping patches. The similar cause
is why Jani Nikula [1] and Greg NAKed cgel.zte patches (ignoring
reviews and "atypical" corporate email structure [2])

Hence NAK (agree with your verdict). However, should the upstream
commit be reverted?

[1]: https://lore.kernel.org/lkml/878rn1dd8l.fsf@intel.com/
[2]: https://lore.kernel.org/lkml/Yylv5hbSBejJ58nt@kroah.com/

-- 
An old man doll... just what I always wanted! - Clara
