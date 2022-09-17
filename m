Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23E75BB602
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 06:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiIQEOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 00:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiIQEOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 00:14:14 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F5183F06
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 21:14:12 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id j12so23028318pfi.11
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 21:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=JKh4l7g3cNogco9tfr19tHwzRFzI37EJeVSPLVfsPzo=;
        b=Y+9N168M7CC4r+JI9RYbfgmfYoBcDDbOwZSYXaGBIPDqTdw968QkzGHmS8OqbhnfZ3
         52LuD93xeP8VBdm4Re9ic9y8AguMVBJ5WaMM5R6/YNqhG2dMyZZBnM8/CsPP0Aufk6op
         bYG7AeTeuNkwpF1c0xMoqmukZkRXcqBaC2xldao4HPq86cVhKW7im7QpiLSpVbf7p0LJ
         yUOGEOuigf95x6YxZcFeDsrevoPHuMTukaBYdueNkxKU34jTdkb642ODGdCM3FPVcRMg
         UBr/rm1dq8u6p+VIyoip6VoMHqjImWh/daUIC0fIrX6qjk1kVg12/p3n6OaTMLRVs3a7
         /Gdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=JKh4l7g3cNogco9tfr19tHwzRFzI37EJeVSPLVfsPzo=;
        b=3NT9SJAXRypMdHbrQ3kavOPxJHOevTt1chLsr5W0ooWUskJgjuIr4EEMDSvxtWI2b+
         /naW1wJr6ld3Uf+uLW2h8w82G6Fz7wvpRaMxIjznoUZhcw3mVVDpXyE3kKzFzo2c/4kE
         8a9oWwOl97uh8PclX/aWzzjC6Avycf0l6pFVb2j61mZSeh/7o08RDnakLIEIJ6hCiktx
         l7LHhyYVUwJY2q+5GLiq4FFwIbsHBUmvWFzem3bFbIqVf3NFFl0KaUuDXJLE38ojQbPn
         e13G4SVaRHAiiV+suo6ahjR2HiKRQMKTuOfHzOOag+mnOobKpgOtN3HmvUePC5BiC7pG
         KPJQ==
X-Gm-Message-State: ACrzQf0SFHAcj9Cks1MqHjyNXu9R181xkZrIuUDuPQQMF7KQQkIzLeDK
        i67xXrAP30caKtXbg+Ez66NSpg==
X-Google-Smtp-Source: AMsMyM59FBUL5qhFHKgAG5oO1oWNtzmWkrAFM+ABlkSvzVOgWahrdeVxtb83SGXncc2iPZo2YAmZZw==
X-Received: by 2002:a63:4f08:0:b0:438:d81c:2d32 with SMTP id d8-20020a634f08000000b00438d81c2d32mr7275208pgb.411.1663388052432;
        Fri, 16 Sep 2022 21:14:12 -0700 (PDT)
Received: from ?IPV6:2601:1c0:4c81:c480:feaa:14ff:fe3a:b225? ([2601:1c0:4c81:c480:feaa:14ff:fe3a:b225])
        by smtp.gmail.com with ESMTPSA id h24-20020a632118000000b00439103a6c3bsm3703050pgh.94.2022.09.16.21.14.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Sep 2022 21:14:11 -0700 (PDT)
Message-ID: <69ddd90e-91fa-78d7-63e6-9d6a8036c6b5@linaro.org>
Date:   Fri, 16 Sep 2022 21:14:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] usb: mon: make mmapped memory read only
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220916224741.2269649-1-tadeusz.struk@linaro.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20220916224741.2269649-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/16/22 15:47, Tadeusz Struk wrote:
> Syzbot found an issue in usbmon where it can corrupt monitor
> internal memory causing the usbmon to crash with segfault,
> UAF, etc. The reproducer mmaps the /dev/usbmon memory to userspace
> and overwrites it with arbitrary data, which causes the issues.
> To prevent that explicitly clear the VM_WRITE flag in mon_bin_mmap().
> 
> Cc:linux-usb@vger.kernel.org
> Cc:linux-kernel@vger.kernel.org
> Cc:stable@vger.kernel.org
> Fixes: 6f23ee1fefdc ("USB: add binary API to usbmon")
> Link:https://syzkaller.appspot.com/bug?id=2eb1f35d6525fa4a74d75b4244971e5b1411c95a
> Signed-off-by: Tadeusz Struk<tadeusz.struk@linaro.org>

I forgot to add:
Reported-by: syzbot+23f57c5ae902429285d7@syzkaller.appspotmail.com

-- 
Thanks,
Tadeusz

