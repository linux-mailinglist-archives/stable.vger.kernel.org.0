Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872B050BC79
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 18:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359308AbiDVQE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 12:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355269AbiDVQEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 12:04:55 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69075C86E
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 09:02:01 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id z16so8410266pfh.3
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 09:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=j/DRPoony39xAyuEQEwrygpJFCr5xS/J71HzZSlHAsc=;
        b=1y65yY7vuM94Cb2DFLSypSKF3EfFIP9EEDZRMMYc7BNAIb8kyV8SH6oP88tqWE12cT
         bce6V1dKCmTJjTmD4azRKGLTHybtP3QUiTBhPBKFR+yxwV4ExgYQEJk251glzy/kuPaN
         lkE9bNd+T3DehLal6fE7fziEnzYMuRh3+ayZRXciw3BXIu2uGLYqzUR7onwoWDHOm5Yl
         cd4g/julRzttzHSCmCBNZBZVI/ZY2alBNtfN1TfkY2tnhSVZsE6s9iKOktgVsYTG24zW
         TSvQdnMRVkjx4q5I6E6A8k6PJULytKbVh4wG8f6qdBporN3yw+5oPZNNMRBNY2hkTCkC
         PaKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=j/DRPoony39xAyuEQEwrygpJFCr5xS/J71HzZSlHAsc=;
        b=2IJgV2N9TQhmuM8s+FONwHgqlRn1GNq/qvDcz4m+1KkUEMl9pU6tLoQakgBDvbrRaj
         kvRcwZ8WQ+m0EVwWDv+Drx5OzVmhGhEK5oSctKRpK4Sd9VTgrQyuYd2t8QaypaNReFcJ
         nhW6jqX+j6R1aFA+JjU9xGB/K2hQ7ijxZk9d2nd06Ii9yKiLZrM7NNHY/lfjy4GVl8XZ
         eKW8FyATCppENBGxduPn2x2FcCZe+hDeJoMkdrtPCm3s4h9kz4HpEq20amJhYuzUoC2R
         ZhvZ3SVF5aApHFubVQ7g+yYbaXEBK9FRvVZQbecAGpDrlW6rQKnKKlQxr22YIbe5Gmxt
         MmIw==
X-Gm-Message-State: AOAM5307LoZ9k4opvyLviY8kNScn+1cXfkry6TD8BPepcGec/zxc6W3+
        PLPznUi9mzTQnuVeQB3SyxbQsw==
X-Google-Smtp-Source: ABdhPJwmDrwA2ZAu5Q1rVNeT+8sU2e3D7ENPevc7XxVgU67wZEV6rG4NaJpcRjtQFBgIZVoVIxhMEA==
X-Received: by 2002:a63:5421:0:b0:3aa:5717:fadb with SMTP id i33-20020a635421000000b003aa5717fadbmr4478084pgb.422.1650643320884;
        Fri, 22 Apr 2022 09:02:00 -0700 (PDT)
Received: from localhost ([12.3.194.138])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090a77c600b001cd4989fedcsm6512927pjs.40.2022.04.22.09.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 09:02:00 -0700 (PDT)
Date:   Fri, 22 Apr 2022 09:02:00 -0700 (PDT)
X-Google-Original-Date: Fri, 22 Apr 2022 08:35:09 PDT (-0700)
Subject:     Re: [PATCH V3] riscv: patch_text: Fixup last cpu should be master
In-Reply-To: <mhng-320b7f4f-08bf-4ee8-938e-4bf687760468@palmer-ri-x1c9>
CC:     guoren@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, guoren@linux.alibaba.com,
        mhiramat@kernel.org, stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     guoren@kernel.org
Message-ID: <mhng-d2e23c07-fd6f-4ae8-a2c7-fc1825e50503@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 21 Apr 2022 15:57:32 PDT (-0700), Palmer Dabbelt wrote:
> On Wed, 06 Apr 2022 07:16:49 PDT (-0700), guoren@kernel.org wrote:
>> From: Guo Ren <guoren@linux.alibaba.com>
>>
>> These patch_text implementations are using stop_machine_cpuslocked
>> infrastructure with atomic cpu_count. The original idea: When the
>> master CPU patch_text, the others should wait for it. But current
>> implementation is using the first CPU as master, which couldn't
>> guarantee the remaining CPUs are waiting. This patch changes the
>> last CPU as the master to solve the potential risk.
>>
>> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
>> Signed-off-by: Guo Ren <guoren@kernel.org>
>> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
>> Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  arch/riscv/kernel/patch.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
>> index 0b552873a577..765004b60513 100644
>> --- a/arch/riscv/kernel/patch.c
>> +++ b/arch/riscv/kernel/patch.c
>> @@ -104,7 +104,7 @@ static int patch_text_cb(void *data)
>>  	struct patch_insn *patch = data;
>>  	int ret = 0;
>>
>> -	if (atomic_inc_return(&patch->cpu_count) == 1) {
>> +	if (atomic_inc_return(&patch->cpu_count) == num_online_cpus()) {
>>  		ret =
>>  		    patch_text_nosync(patch->addr, &patch->insn,
>>  					    GET_INSN_LENGTH(patch->insn));
>
> Thanks, this is on fixes.

Sorry, I forgot to add the Fixes and stable tags.  I just fixed that up, 
but I'm going to hold off on this one until next week's PR to make sure 
it has time to go through linux-next.
