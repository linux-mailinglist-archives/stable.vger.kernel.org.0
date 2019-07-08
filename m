Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3453762727
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 19:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbfGHRcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 13:32:05 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39854 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbfGHRcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 13:32:05 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so7550840pgi.6;
        Mon, 08 Jul 2019 10:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QjUEkPv4P+Cy2J8UDrDe7tC4X9k/PrOqSnXPrXrMZ0o=;
        b=P7OmmvT9qUPz4Q2jOi6EudZyZpLai3Ujd4NkWZsBXpfttOPyaUi/fO+JX+fzH5i+jc
         icZ+H55j+LYgHnYyCT/8Wq3CRakvbuaUSWkpnrZ8vPxKliFgk79dG9yMrkH0OiQMV7/A
         dgcovcZ8hCWWjE1JHg8gjGuPqN9VKz0J8Xe56huTYb61LCrzKel6/Yl24vwcDMCcQKDf
         BLd7haQjUftRSO+9sUqs3Eno2RTbkwu4rnI55pdXWT3JDNnln981CcRZq/Kd2W0p+YxG
         Y7Cwt06zNErLLPdWEiQ9Ec2yNZaN7l/slFh0G99w/ny3p21HvMpCSEm1V6TRK9qLPPH6
         pL7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QjUEkPv4P+Cy2J8UDrDe7tC4X9k/PrOqSnXPrXrMZ0o=;
        b=UpswYZWr+w2wVmFn+P9uL+xzZiQ1JBDX5D8ZY9x4VBd5wr3DYMl/CnW0PalrLQL/n/
         8rx6UtpxWTFxC88oWJGW5TsHr4NnB1eJA/HFJNTFIngSxv28bR5IO0wGmpfvzKNlmxgH
         1U0gkPk5oCGq/QB1yV1QAJVfbxS+7PqgTAKk78hTo286EVdwVJyiZ7KrPQDpBW7H/v/s
         HTj++k7VGM+Hn6PZfH1lBi//pNK/aWMl6E97f9ZnLTHdSbwDp08Z6tI0BnfdmDttRVve
         pLALj+6cSpr+knDlZpQ5dmNsCtEx9fZmpccDowKc0Ru+diib8gccz2Id3AwHz2Ci2zkD
         lyKA==
X-Gm-Message-State: APjAAAWa/qUj9fbli1Xkn9luxJhyADIN+gsLnw25FTrA1iu/T3EsSnDj
        51dFj85xUdeTPJsFdmIwC8Ek/+jl
X-Google-Smtp-Source: APXvYqyDtH5XEv0eDy+zBirZWyA+V6EBbNsJFDgWLiV0z5QhjjEBc3y33bzuvYg3Y7d9hp/Lrxz9ug==
X-Received: by 2002:a17:90a:cb12:: with SMTP id z18mr26151131pjt.82.1562607123901;
        Mon, 08 Jul 2019 10:32:03 -0700 (PDT)
Received: from ?IPv6:2405:4800:58c7:1881:3232:ec6:81a5:864b? ([2405:4800:58c7:1881:3232:ec6:81a5:864b])
        by smtp.gmail.com with ESMTPSA id c5sm13926328pgq.80.2019.07.08.10.32.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 10:32:03 -0700 (PDT)
Cc:     linux-kernel@vger.kernel.org, tranmanphong@gmail.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/90] 4.19.58-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
From:   Phong Tran <tranmanphong@gmail.com>
Message-ID: <dc42cab7-d124-e4bf-2ddc-0d57cc338662@gmail.com>
Date:   Tue, 9 Jul 2019 00:31:59 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 7/8/19 10:12 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.58 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.58-rc1.gz


compile and boot fine with  qemu-system-riscv64 -nographic -machine virt 
      -kernel riscv-pk/build/bbl -append "root=/dev/vda ro 
console=/dev/ttyS0"      -drive 
file=busybear-linux/busybear.bin,format=raw,id=hd0      -device 
virtio-blk-device,drive=hd0


root@(none):~# uname -a
Linux (none) 4.19.58-rc1-00091-gc4064b656955 #3 SMP Tue Jul 9 00:25:27 
+07 2019 riscv64 GNU/Linux
root@(none):~# cat /proc/cpuinfo
hart	: 0
isa	: rv64imafdcsu
mmu	: sv48

Regards,
Phong.
