Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6321E19EF
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 05:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388547AbgEZD3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 23:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388497AbgEZD33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 23:29:29 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CC1C061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 20:29:29 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bg4so2803080plb.3
        for <stable@vger.kernel.org>; Mon, 25 May 2020 20:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:autocrypt:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=VQAiqAOL/gK3oszHu5HRxGGea/r+zBYLh1lOURd8mfE=;
        b=sbNsKyve8LjOwLIMGjK6OQgaTpxTSmzwQWcNAn+u2bxelcffSafxcYYofOaAcaK530
         3Y95hpcsWzZZnBvtjRTY6dYrmy/4AX28hNe9VcaevoUETEPGp63AxecljZjgy6tjYLhg
         nMy67Zx4AteadC2rMtWAFr30Ze6zNQ5e+ZS75vxmPPRpV11NGt/js8bbs2SbyyaakUQs
         aB+ocjPTL05vj16ijBtWCQj9t0vt9BPJ0v1ABZw/viJr2e8GcJZiA35GO2LDX3rgiIyx
         d+l0AMZMZvQmT1GFKhwla1ETvdck81JW/kQ0F6kdveCn2TzrA45qWbk5PWWz98ZEAEET
         F6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:autocrypt:message-id
         :date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=VQAiqAOL/gK3oszHu5HRxGGea/r+zBYLh1lOURd8mfE=;
        b=nAT910btHE5ZNyX1vcopB65URSjfjmUVVc3/mglUvYRHW/shnnyKeO83CxJnH2zs9l
         2Y4sC3QYEtPDI5VnV9EvGq3f2lAtW4MznUtlRKWv1mQvfUOiWNgztLcAQ5ZblNRyMQxb
         oVdHiwUjzqmhFq7TuE5WysXG+JADZ3GG8DnwjwlgX89uxL6JVIpJ/X+Ka4hYRAJzMmEY
         Ll5Nv3PR9XsuRw5vcWRwbYchbkSjR4GjtF9LyX7/KbfHmYiTn5WSq9MM5sT60X8hdm8R
         0EJSAI0ZF/YKoqGq2LMxO6hCzcyvioNOPY9IdHISjhd8q+l4wfoiaJ5YyFUUtSV9abU6
         Q0Gg==
X-Gm-Message-State: AOAM5301LfDuXNv4uNOe0R8OdrW6yXkL9h+sTz0c5vIaIhp6zAfNWIah
        4+hDJgkoaYc7nj4H+waUxlIRPC2Y
X-Google-Smtp-Source: ABdhPJwjG0/wIiIOh7hmymTfY7vPkDxwtwp7G2BB51U7ZECeYerqG1uOg16fZIbr+Ls2xrGanMA2fQ==
X-Received: by 2002:a17:90a:f409:: with SMTP id ch9mr24111660pjb.101.1590463769040;
        Mon, 25 May 2020 20:29:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h7sm12656175pgg.17.2020.05.25.20.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 20:29:28 -0700 (PDT)
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Olof Johansson <olof@lixom.net>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Build failure (riscv) in v5.4.y.queue
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <80234d43-3848-45e8-6d70-1db94129e35f@roeck-us.net>
Date:   Mon, 25 May 2020 20:29:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Build reference: v5.4.42-105-g3cb7994
gcc version: riscv64-linux-gcc (GCC) 9.3.0

Building riscv:defconfig ... failed
--------------
Error log:
arch/riscv/lib/tishift.S: Assembler messages:
arch/riscv/lib/tishift.S:9: Error: unrecognized opcode `sym_func_start(__lshrti3)'
arch/riscv/lib/tishift.S:29: Error: unrecognized opcode `sym_func_end(__lshrti3)'
arch/riscv/lib/tishift.S:32: Error: unrecognized opcode `sym_func_start(__ashrti3)'
arch/riscv/lib/tishift.S:52: Error: unrecognized opcode `sym_func_end(__ashrti3)'
arch/riscv/lib/tishift.S:55: Error: unrecognized opcode `sym_func_start(__ashlti3)'
arch/riscv/lib/tishift.S:75: Error: unrecognized opcode `sym_func_end(__ashlti3)'
make[2]: *** [arch/riscv/lib/tishift.o] Error 1
make[1]: *** [arch/riscv/lib] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [sub-make] Error 2
--------------

Looks like 28ac255f31d7 ("riscv: Less inefficient gcc tishift helpers
(and export their symbols)") may be missing some context commit.

Guenter
