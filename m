Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E974A580A
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 08:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiBAHpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 02:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiBAHpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 02:45:18 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F908C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 23:45:18 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o64so16352876pjo.2
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 23:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=9y17tnaU22axbKYtYGekGdZ0DT2vnLRd55NXO3RPNTk=;
        b=Bdc3rPC7WwE+cT+PvvSZHVwFbzgi7OxHbta7kNx987NzSVMVaAgAhyedAIEhVw6Idv
         YStvEsOWcqwLNLPNB33LnrhpnLg1olpUaR3GJVb/9NhUctYSWJiIlXaIeT9G3LLCbchB
         rClMzsu5oJb2qEX5ufEWKL6BTEO4RXewroIVMd+XZH0dmVa30dUR2ARQfov+Llvi7McF
         E++HOctOJrxRkgVsoV0JXd3GE+kyTjWnzjBjJ6MgX0sFV4GSMLaAfAIRQ4IGvq/Zn8X/
         gdsaKsb2DvV3VToNToRUOPSdnTFa3LiWLVk2/zZXbnhEDshGeWMJ3AMGFH5GLgtw/ceE
         GE+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=9y17tnaU22axbKYtYGekGdZ0DT2vnLRd55NXO3RPNTk=;
        b=WPDEh5OLCpc6Yt09FdJNTQRLKEaJgna0Esf+kA8OGjFifwKFPVjOO+apzfkLivwgK3
         yxeZR06PcGAVEze1difEucQu32KWr1pizctVaqqeZm1yzrLfNjfMncLfiNurrFJyWZhr
         l9qcVP5K4fmlkpK7BF9woGeSHIFEQWP4ZsMaBeNrM1LYJ+gpg1ALsa98HVPbj7alywPW
         28eRqUEwcECOO0NK3HQ5Q8mTctLvCxr7bIBODJRV3GBIh9+zctUyOfLlvZVGyI0CLdvq
         O8G+yKvedBO130pUQvuzlXDoMuzz7IDsCe+SsU5f1yMrWCyw/mjm2YozPh5p6TI2LPZz
         wMlQ==
X-Gm-Message-State: AOAM532DS7vF1zbI+hf4K/pC4dt/08uA92ZWjNuf+an0OJ7sAbcx4qM3
        fxkR6jzXY29NDCG+GKBsreJSSYdH3Mm+fA==
X-Google-Smtp-Source: ABdhPJwvNFVGFGQsilOPwtDZzla0igGeuPLXGMqFb9idPY0PJZKHn6TR5OQ+Q+ChJmYIQvZV1D/OHQ==
X-Received: by 2002:a17:90b:4f4c:: with SMTP id pj12mr895945pjb.102.1643701517804;
        Mon, 31 Jan 2022 23:45:17 -0800 (PST)
Received: from ?IPV6:2601:206:8000:2834::19b? ([2601:206:8000:2834::19b])
        by smtp.gmail.com with ESMTPSA id q21sm21962886pfu.104.2022.01.31.23.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 23:45:16 -0800 (PST)
Message-ID: <93b0cbcf-a825-d0e1-92bc-5a2f323b3393@gmail.com>
Date:   Mon, 31 Jan 2022 23:45:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
From:   Scott Bruce <smbruce@gmail.com>
Subject: Linux 5.16.5-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Sorry for the out of thread mail, gmail appears to have some issue 
delivering any of the review thread messages to me at the moment.

5.16.5-rc1 build/boot looks good on x86-64/AMD Cezanne; No build or 
dmesg regressions and 10 or so s0ix suspend cycles pass without any 
obvious regressions as well.

Built and tested with both GCC and Clang/LLVM on an ASUS GA503QR G15 
using Arch Linux.

Tested-By: Scott Bruce <smbruce@gmail.com>
