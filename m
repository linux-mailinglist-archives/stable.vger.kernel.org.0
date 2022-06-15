Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A67A54BF10
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 03:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiFOBGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 21:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiFOBGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 21:06:44 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608D03EBA4;
        Tue, 14 Jun 2022 18:06:44 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 31so8360125pgv.11;
        Tue, 14 Jun 2022 18:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hsIakku4FnVx99K8632PhAPuzZKXQqxNFY60mWq6fhY=;
        b=PZtwOpTSO8PjeTx6/6jNFf+M4XWpL8halrvUQJjg8NTHIByf/qy+RGIEjbmGMJq+d7
         zuMqo/2vMqMYH2tLYpZrPFoPmZnSuzhbxymRY7ZV8+ugj5Jd6EGFRHEGtjRDsYoUJ4sm
         aeGOr3WJO827uNDIQh1i4FRbvlNot95n/LcEx+jnzavIwhFn5bg7bi+lJRVppzE220ua
         kkqLDgnD9hBc4T1MGUGc7eKu62A5RbgTJi+nJMUKaDgckC/iQh6zmCJFUBdRhv5YoP/u
         VcGAgTigIIgXZ7t3BaF1PFIquuynKMtr41a8W7BiiMJttzkopQQpw3kwwpM7Qfp7FHj8
         J0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hsIakku4FnVx99K8632PhAPuzZKXQqxNFY60mWq6fhY=;
        b=5hS2oYeHDrd2ntfLlNsxLjXw0kUEAEJhpqH80hQm1IXdb8+D9fqWLq3wmkI6yCk8Ol
         sUsediadt+7qrqTAqAjQIx4+0vEW4Dd6xwwgdCsK4lapjQZCCyuEu//8ns+pA0mQN4Sm
         mb4GG/+VEQ8ihEts2B8/hl+XPAOj0p+KmNJ0gX0TAbsxAThRSEmg/kuVUUj70w5iOzwk
         NS8noR4UX5ZUbdORCKEUSA8IBvlas/21C896Z6NNtnovgo/Z7Fe+lTRVjb0eFNvWjQ6M
         F+HOLsmzbgbpjWlHShL0UdmqwEXy4zC1zBngwHhbvs8kcDEGbfJMli+xoN3TJRKr3Iwd
         7lHA==
X-Gm-Message-State: AOAM530B0zXCou34luKZILSAYh/GIacm5e07GMbvxNkTjaMCiYmfL1yO
        R8WFppmNNWx4II2/xtT63s/jbp9Ue20=
X-Google-Smtp-Source: ABdhPJxNlZaPX57z0XJyh3gcPU4N3Iqz2gzpfXQUutDHW8rM86PpNhgK8+6Ksu19MbeMEVwsVTx0xg==
X-Received: by 2002:a63:5fc3:0:b0:3fd:f15d:5df6 with SMTP id t186-20020a635fc3000000b003fdf15d5df6mr6512040pgb.573.1655255203857;
        Tue, 14 Jun 2022 18:06:43 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-7.three.co.id. [180.214.232.7])
        by smtp.gmail.com with ESMTPSA id v11-20020a1709028d8b00b001616e19537esm7821759plo.213.2022.06.14.18.06.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 18:06:42 -0700 (PDT)
Message-ID: <94468546-5571-b61f-0d98-8501626e30e3@gmail.com>
Date:   Wed, 15 Jun 2022 08:06:37 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.18 01/11] Documentation: Add documentation for Processor
 MMIO Stale Data
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20220614183720.861582392@linuxfoundation.org>
 <20220614183721.248466580@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220614183721.248466580@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/15/22 01:40, Greg Kroah-Hartman wrote:
> +  .. list-table::
> +
> +     * - 'Not affected'
> +       - The processor is not vulnerable
> +     * - 'Vulnerable'
> +       - The processor is vulnerable, but no mitigation enabled
> +     * - 'Vulnerable: Clear CPU buffers attempted, no microcode'
> +       - The processor is vulnerable, but microcode is not updated. The
> +         mitigation is enabled on a best effort basis.
> +     * - 'Mitigation: Clear CPU buffers'
> +       - The processor is vulnerable and the CPU buffer clearing mitigation is
> +         enabled.
> +
> +If the processor is vulnerable then the following information is appended to
> +the above information:
> +
> +  ========================  ===========================================
> +  'SMT vulnerable'          SMT is enabled
> +  'SMT disabled'            SMT is disabled
> +  'SMT Host state unknown'  Kernel runs in a VM, Host SMT state unknown
> +  ========================  ===========================================
> +

Why is list-table used in sysfs table instead of usual ASCII table in SMT
vulnerabilities list above? I think using ASCII table in both cases is enough
for the purpose.

-- 
An old man doll... just what I always wanted! - Clara
