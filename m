Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3547E4C96AA
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238325AbiCAUZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238451AbiCAUXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:23:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 894FEA1452
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 12:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646165953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3FMkSD7aKPC9JzNCskfAuhPbmqVixaqKWqBwlf8S+9I=;
        b=HoNkIjNXg/YlD3H5jB/q4tPTmwsJJIqtgWPH6hFBIYVgXQ03DHUHEwyG2r+Hs90ZcwC3Qc
        253Dp+Y1eWpK0EHtlXfiv0ShAd963+f1HJoZ22hWwm645bu65jLIvB2q71A+o298ef6T24
        Ed1za74uTpSGB+2HqKUjkbSa7ID+4xg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-iY063jvfM-m23vKGXYSzkQ-1; Tue, 01 Mar 2022 15:19:12 -0500
X-MC-Unique: iY063jvfM-m23vKGXYSzkQ-1
Received: by mail-wr1-f71.google.com with SMTP id t8-20020adfa2c8000000b001e8f6889404so3759745wra.0
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 12:19:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3FMkSD7aKPC9JzNCskfAuhPbmqVixaqKWqBwlf8S+9I=;
        b=niKvrD7vaZjZbsa2Td4bCpgRrRcvCzBQEOCPuPLnRZilu3617X3bsr72HX+QU+eJYJ
         jm7GoR0XDDlAq+9sb9NSaWbFz11ZOgnx8f+iAYsPxy8A7d7DX2B9CVpUssd6ih5Rqz4E
         uHw4Ghqh/MnoB4+3RQdkuGkbYX1ryYHXtR81q8ooGfmjr4+dOyi/txy5xfDOHqK0ZTQx
         an3Rnn5WMnXgCFodWZneewIu3Nsy+Q+AKsZy5HMclQlXUWARnN8PYpBL5HjKNop9n9te
         8kfqMpotXuNIZuy6pFV30edF8dLTH1Q4nOuQ6PWZNuFoFSFfYYVVTm4r36k/GL2eMaKs
         rakw==
X-Gm-Message-State: AOAM531/thAPROoFVf7f2gqk3MH6sd7faJ7ZVa3w4AcEkbI9RJ5wiy3X
        ng/Hzcya++A2teSTWtRiXqOP51Nc9TbMR4iGbrd9MALODP4oRz3upTZRHJtV3Mm64h0pWHcHDSj
        KEvnUod+v+T/EBdCf
X-Received: by 2002:a05:600c:34d2:b0:381:7817:f5f2 with SMTP id d18-20020a05600c34d200b003817817f5f2mr6933012wmq.23.1646165951057;
        Tue, 01 Mar 2022 12:19:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBntNzfgavWPnhM1XNJk6gt7pEibOFJYJrpIhZSS48oHJVOgFdHq+mIBx2l9FoRFPmA0lk9w==
X-Received: by 2002:a05:600c:34d2:b0:381:7817:f5f2 with SMTP id d18-20020a05600c34d200b003817817f5f2mr6932996wmq.23.1646165950789;
        Tue, 01 Mar 2022 12:19:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id r17-20020a056000015100b001ea7db074cdsm20011822wrx.117.2022.03.01.12.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 12:19:10 -0800 (PST)
Message-ID: <d09b9c37-07fe-fdbb-9647-4f27dd1c400d@redhat.com>
Date:   Tue, 1 Mar 2022 21:19:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH AUTOSEL 5.10 02/14] KVM: Fix lockdep false negative during
 host resume
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org
References: <20220301201833.18841-1-sashal@kernel.org>
 <20220301201833.18841-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301201833.18841-2-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/22 21:18, Sasha Levin wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> [ Upstream commit 4cb9a998b1ce25fad74a82f5a5c45a4ef40de337 ]
> 
> I saw the below splatting after the host suspended and resumed.
> 
>     WARNING: CPU: 0 PID: 2943 at kvm/arch/x86/kvm/../../../virt/kvm/kvm_main.c:5531 kvm_resume+0x2c/0x30 [kvm]
>     CPU: 0 PID: 2943 Comm: step_after_susp Tainted: G        W IOE     5.17.0-rc3+ #4
>     RIP: 0010:kvm_resume+0x2c/0x30 [kvm]
>     Call Trace:
>      <TASK>
>      syscore_resume+0x90/0x340
>      suspend_devices_and_enter+0xaee/0xe90
>      pm_suspend.cold+0x36b/0x3c2
>      state_store+0x82/0xf0
>      kernfs_fop_write_iter+0x1b6/0x260
>      new_sync_write+0x258/0x370
>      vfs_write+0x33f/0x510
>      ksys_write+0xc9/0x160
>      do_syscall_64+0x3b/0xc0
>      entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> lockdep_is_held() can return -1 when lockdep is disabled which triggers
> this warning. Let's use lockdep_assert_not_held() which can detect
> incorrect calls while holding a lock and it also avoids false negatives
> when lockdep is disabled.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Message-Id: <1644920142-81249-1-git-send-email-wanpengli@tencent.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   virt/kvm/kvm_main.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d22de43925076..06367f2d55000 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4758,9 +4758,7 @@ static int kvm_suspend(void)
>   static void kvm_resume(void)
>   {
>   	if (kvm_usage_count) {
> -#ifdef CONFIG_LOCKDEP
> -		WARN_ON(lockdep_is_held(&kvm_count_lock));
> -#endif
> +		lockdep_assert_not_held(&kvm_count_lock);
>   		hardware_enable_nolock(NULL);
>   	}
>   }

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

