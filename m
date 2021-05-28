Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E6A3940BB
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236436AbhE1KOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:14:14 -0400
Received: from mail.loongson.cn ([114.242.206.163]:58024 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236551AbhE1KON (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 06:14:13 -0400
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxL0MNwrBgJ8YFAA--.5536S3;
        Fri, 28 May 2021 18:12:29 +0800 (CST)
Subject: Re: [PATCH 4.19 00/12] bpf: fix verifier selftests, add
 CVE-2021-29155 fixes
To:     Ovidiu Panait <ovidiu.panait@windriver.com>, stable@vger.kernel.org
References: <20210527173732.20860-1-ovidiu.panait@windriver.com>
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <3d25a908-6d1a-482f-106b-5d894c3cab87@loongson.cn>
Date:   Fri, 28 May 2021 18:12:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20210527173732.20860-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9DxL0MNwrBgJ8YFAA--.5536S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GrWUXFWUCr4xWrWkXFW8Zwb_yoWxZFXEkr
        W3WFZ8Crn8Ar4UWay2yFyxurn8KrW3X3WSya40vwn5G3s5XFn5JFsaga4rAr93u3WfCrsr
        JF13Gws5XFyY9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbIAYjsxI4VW3JwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWxJVW8Jr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l
        c2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
        0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWU
        tVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
        CY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv
        67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyT
        uYvjxU75l1DUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/28/2021 01:37 AM, Ovidiu Panait wrote:
> This patchset is based on Frank van der Linden's backport of CVE-2021-29155
> fixes to 5.4 and 4.14:
> https://lore.kernel.org/stable/20210429220839.15667-1-fllinden@amazon.com/
> https://lore.kernel.org/stable/20210501043014.33300-1-fllinden@amazon.com/
>
> With this series, all verifier selftests but one (that has already been
> failing, see [1] for more details) succeed.
>

Hi,

It seems that some patches about F_NEEDS_EFFICIENT_UNALIGNED_ACCESS
are also needed?

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?qt=grep&q=F_NEEDS_EFFICIENT_UNALIGNED_ACCESS

