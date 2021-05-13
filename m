Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534F837FF5D
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 22:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhEMUkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 16:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbhEMUkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 16:40:42 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82094C061574
        for <stable@vger.kernel.org>; Thu, 13 May 2021 13:39:32 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id t7so20809196qtn.3
        for <stable@vger.kernel.org>; Thu, 13 May 2021 13:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=7so98JrjeQ0e2ihEDvq6k/d7+L7t8wmXvRESCXcffvU=;
        b=bKRBRwV5z3/+3qXqWith6SPdtzX75mxUMLIUQ5Fi3gxqEVw91glLciqX7EjUfHOzB8
         +hu19IpqPFu2HbZaQYxe8Tm09TWn+yp5koNX9UfZjy/thc6+Y5xqQNW5O0CLY8VpOVXN
         CS1k1DEf8d0U3tdHRN8+4lO8sg3RtzmQUfaCiGUtxtdGXa9jjmUB2rBjvGf3SKRNDXPW
         EwUH7+bOxXfdy3VDXG0nyBBFNyDLML1oZHztPPSc3cbpTW/nolwZGuaRVmJerin8ejXJ
         MHZZ9a2WqZ/60UAwA4vJFnWN5BoAcyBpIPpDD/hFyUnol1GY460JCiNAwBdSx/xf0k60
         UTKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-transfer-encoding:content-language;
        bh=7so98JrjeQ0e2ihEDvq6k/d7+L7t8wmXvRESCXcffvU=;
        b=Y1gfcpHVBeCRcn458Ojq5R5cP+nSeId54aGxTu41BniPVCJbFYMJP1y7VyN5da+PdS
         /qBKHfKNOuSSCAzL04i4bFrTA1wFmGfW0FjJpLrBKtjeD1lJ8HgMbUZ/EImXyfU3VHaZ
         cfFcW7HdI/Rb2euTyhGw30Xk7oRb+o1l1obauRiN/J3G48hK4vzs8OWhaFva3MMlm+pY
         DaLffJmRD4Tuo4yVEbn4qroDtK3WUPRP+BfiIOy89UFaRJp6fjfjy4KC+KGwEtQnG7pR
         7aD14mmsJEhNa9ZKJ9KcrbtUqdSXnT20aw1WQSn4ZOAMB5p86y49ZD+uFswEh8hpf753
         czgA==
X-Gm-Message-State: AOAM533BeqJzTeUsY4pVeMBtzi4HjiHxjP4W+f9+dtRMqk4ZvEvfyQTc
        rhvkx48T19Bt4M1/wkHQSwMBSY3mPUc=
X-Google-Smtp-Source: ABdhPJzlj/Gtf0ca4nzEzEqXHECIneDkoQVg5QV9hQYAWlKvkM+qBGXeMvsvFkUC0m3HJHAas8miAw==
X-Received: by 2002:ac8:4447:: with SMTP id m7mr20627850qtn.55.1620938371804;
        Thu, 13 May 2021 13:39:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b1sm3021360qtt.67.2021.05.13.13.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 13:39:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Build failures in v4.9.y.queue, v4.14.y.queue
Message-ID: <438183ba-d285-42d1-e787-c332ce83ca0b@roeck-us.net>
Date:   Thu, 13 May 2021 13:39:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Build results:
     total: 168 pass: 168 fail: 0
Qemu test results:
     total: 406 pass: 405 fail: 1
Failed tests:
mipsel:mips32r6-generic:malta_32r6_defconfig:nocd:smp:net,pcnet:ide:rootfs

This is the same mips assembler related build failure that was also seen
with all other release candidates.

Guenter

