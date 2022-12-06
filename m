Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C46A6447C1
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 16:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbiLFPQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 10:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbiLFPPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 10:15:45 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A4C2EF00;
        Tue,  6 Dec 2022 07:11:51 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-14449b7814bso12793522fac.3;
        Tue, 06 Dec 2022 07:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U2aqfWiC18IWaJPfen75guUebWdcC57mYfUOjSginJ8=;
        b=X7P/ipumWPrS53pnFJPhLt9S4ZXC7xstFKw+LYRBYGoL8V0635Ef1gkYhcHKzrb5f+
         MnlhsS3zuxOw6FgQJzYWNFVPlP72Fxi3cjXv0Mn02oa0Kpc0I7OoLMMnHcbfzjJjWoBD
         FCxxZhOh322UZ9AEOQpL5Bj3+/3JUvzcZ9/g/bM9Azk0VvxCsY3epXqZT6C9GI1dg2jh
         B+4hTmqjjLQkq4dd/+Bycm6d0CWrvTterUKqz1nvNKCBibmHtLrpHgNQHwpFts0k1/EO
         1ZdnlgJs/mT8Id2NlA0DXnbbio5r/chWWGhX3/lmUpe2WPR2x/nkGEQQbXnqLEStA55o
         MH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U2aqfWiC18IWaJPfen75guUebWdcC57mYfUOjSginJ8=;
        b=eo716D619xsd8JSLvR1ODpBlFV6Un2iM0c4jRqKXjCNfrYL6lO/uzLhvTOqhxwnHA7
         +aLhLyOBZmQJF06WmcHEQLiGT/ifkZlov8rEAhhtpTONfuKmB1tGpbTRoaiCv6zH9wH3
         LIkGAJ5w4Y2Rf9G4R/3ccNr+ZlkIullfYFHko+1OQ0zrUJ6xTtuqNT5cvvdaCrXLsIPS
         zNcOCgHWpRBP/UzaFY7/tyDhRWkdFJ5xc114TEUaoF8I10L9PxLxsNIJhLa4JvPD9m3a
         OkoIbU6sh8/Xmi+IvFbWXkuGvSTbB8/CIT/LNspmlpprD/tLdzc3oqv+dBa8swpfiWAi
         eriQ==
X-Gm-Message-State: ANoB5pl8atDYpCDttJfez94JwhrY3QDlFxcyXK+jE1VKDfea4B3405f4
        uBgJyg5Ss6b8uY7fVqteuJg=
X-Google-Smtp-Source: AA0mqf5k6TyODTmFnas1gSjxxVcp5bgqj2cC6uaE41NtITw/OPvmc0Mnf/joQBZzQK8uqXxfMoApAg==
X-Received: by 2002:a05:6870:9d95:b0:13b:a163:ca6 with SMTP id pv21-20020a0568709d9500b0013ba1630ca6mr53683510oab.125.1670339501593;
        Tue, 06 Dec 2022 07:11:41 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ce11-20020a056830628b00b00670461b8be4sm2200619otb.33.2022.12.06.07.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 07:11:41 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <792a6fba-aa15-2e2a-7527-99ab1116a01d@roeck-us.net>
Date:   Tue, 6 Dec 2022 07:11:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20221206124052.595650754@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.15 000/123] 5.15.82-rc2 review
In-Reply-To: <20221206124052.595650754@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/22 04:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 

arch/riscv/kernel/smp.c: In function 'handle_IPI':
arch/riscv/kernel/smp.c:195:44: error: 'cpu' undeclared (first use in this function)
   195 |                         ipi_cpu_crash_stop(cpu, get_irq_regs());
       |                                            ^~~
arch/riscv/kernel/smp.c:195:44: note: each undeclared identifier is reported only once for each function it appears in
arch/riscv/kernel/smp.c:217:22: error: 'old_regs' undeclared (first use in this function)
   217 |         set_irq_regs(old_regs);
       |                      ^~~~~~~~

This is with v5.15.81-124-g9269e46bc838.

The backport of commit 9b932aadfc47d seems wrong. The original version introduces
the cpu variable in handle_IPI(). The backport doesn't, and removes old_regs
instead.

Backport:

  void handle_IPI(struct pt_regs *regs)
  {
-       struct pt_regs *old_regs = set_irq_regs(regs);
         unsigned long *pending_ipis = &ipi_data[smp_processor_id()].bits;
         unsigned long *stats = ipi_data[smp_processor_id()].stats;

Original:

void handle_IPI(struct pt_regs *regs)
  {
-       unsigned long *pending_ipis = &ipi_data[smp_processor_id()].bits;
-       unsigned long *stats = ipi_data[smp_processor_id()].stats;
+       unsigned int cpu = smp_processor_id();
+       unsigned long *pending_ipis = &ipi_data[cpu].bits;
+       unsigned long *stats = ipi_data[cpu].stats;

Upstream includes commit 7ecbc648102f which removes the old_regs variable.
That doesn't mean it can be removed in the backport.

Guenter

