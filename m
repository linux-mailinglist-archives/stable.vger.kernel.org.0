Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5757C23BFCD
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 21:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgHDT1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 15:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgHDT1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 15:27:46 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C9EC06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 12:27:46 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id l60so3043717pjb.3
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 12:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:autocrypt:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=VdnXVMTbKI+GgEjUvFSIBBwN0/tVTet0qzZ46YHCk7s=;
        b=tWyXwO/VSZUfARVZvmptyPKAFcvrJt4tc5yvYEZ6Tz8c4fjqoEty1oditdG7P8GmJM
         aitXULZ29CbUR3C0mJedgNntK6779eLSs9Y/dKJzGjUFknm96tIf+CrycOXmGuJzCPJP
         vPYQ5XpkeHsoGfHsfNMgpovkFvfIXxxHaeFfr8aj8NSo0oxGpRJb37Jt1qTUEQrtqgG8
         PKo2LlnDPe8qVeXXmtvdQPswzlxlH+NaV+QuzGGGlVCfpIk+G5rjmQp5zfjDDvmaYgZp
         Q/ov2GyPi6UJrly9aJ6/MPSqpm1jIO46lBpzo1W1zVa5tOI4Iz8gpi8ajoQIC7xU0P70
         48Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:autocrypt:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=VdnXVMTbKI+GgEjUvFSIBBwN0/tVTet0qzZ46YHCk7s=;
        b=MBvVB+QI0E0qgLESVSE1S8ORsUqhIIGWm7qG0NrIWpu1FfJwjoYNYiIWDQEbOGdRPw
         at0v6PTiZpYbqu/bPT5xUG/dU189pzLxy2BLkjDikb56Ua6XcdTXFwekRBSPZNjFHu7H
         ugtEgG0t1wSwnlKwYqdp/qZVcUDGH58o1U6AhCRXMW0hs5ymu7ZkzPYql448Sw3leK9b
         imz4d0zwmYXdD9mjRhCcJQlQmNUkKC5ldYBgowsUvmwKHH2qN39Rm5G9Fd/kDJ8neVrm
         73F2SGdj/HJkk3e7cje9ihijpjKgJpZVQ6JArTXb+621aXW9W/+7mfC6sPiJsDC7jgeX
         J5Jg==
X-Gm-Message-State: AOAM533s4ncl8X91R3Q5aqzzXrDfSGr838/rkJchG/3VDnVo722suk2o
        tMjbx7xgC5CYk3lpTLadDSg=
X-Google-Smtp-Source: ABdhPJwYt5qphaFLWxrch0Hre+ElRe+jgbSHVsO27ci0yDN/CPzq6wQsQl7ADZFw/Lq3Ix6IZKyhBg==
X-Received: by 2002:a17:902:8f8c:: with SMTP id z12mr11425180plo.53.1596569266447;
        Tue, 04 Aug 2020 12:27:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 193sm7473062pfu.169.2020.08.04.12.27.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 12:27:46 -0700 (PDT)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Boot failures in v4.4.y-queue
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <89294140-4b19-0116-95e3-016295f96e09@roeck-us.net>
Date:   Tue, 4 Aug 2020 12:27:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

all x86 and x86_64 images fail to boot in v4.4.y-queue (v4.4.232-30-g52247eb).
Bisect results below. Reverting both 3bc53626ab45 and d1c993b94751
fixes the problem.

Guenter

---
# bad: [52247eb98ebec43288b5da7033c5b757a6fbd1d0] Linux 4.4.233-rc1
# good: [e164d5f7b274f422f9cd4fa6a6638ea07c4969f1] Linux 4.4.232
git bisect start 'HEAD' 'v4.4.232'
# bad: [3bc53626ab45d3886eef382b83973969dc6fc429] x86, vmlinux.lds: Page-align end of ..page_aligned sections
git bisect bad 3bc53626ab45d3886eef382b83973969dc6fc429
# good: [34fda3ae46a68f53e4b18d9b5b560a9cecabb072] scsi: libsas: direct call probe and destruct
git bisect good 34fda3ae46a68f53e4b18d9b5b560a9cecabb072
# good: [994de7ca7e88d4c5e8893bd695dadf9af4751bc6] f2fs: check memory boundary by insane namelen
git bisect good 994de7ca7e88d4c5e8893bd695dadf9af4751bc6
# good: [93aa53738c81fc0e286b8cb37533e9697ae7ea6f] ARM: 8986/1: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints
git bisect good 93aa53738c81fc0e286b8cb37533e9697ae7ea6f
# bad: [d1c993b94751c4a84604711b378906ab91fb16ad] x86/build/lto: Fix truncated .bss with -fdata-sections
git bisect bad d1c993b94751c4a84604711b378906ab91fb16ad
# first bad commit: [d1c993b94751c4a84604711b378906ab91fb16ad] x86/build/lto: Fix truncated .bss with -fdata-sections
