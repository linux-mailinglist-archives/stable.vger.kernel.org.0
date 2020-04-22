Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33441B4DB5
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 21:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgDVTw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 15:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726079AbgDVTw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 15:52:28 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC366C03C1A9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 12:52:27 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id l19so3684394lje.10
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 12:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=VkFY9VA5eLaLmOjmzlzXKbbW8wSFipjY4LA9MnWoz+4=;
        b=I8hfuQAFNBmhOHu5r31vWndzA0+jY1L9PfO2YihbnK8aT1+SCPNt7rIkDxyrN+r4+Z
         S0gRfB3ztkpZwWjJDrtWCbdIbHyWfp7kDHWFem6vqrC8rico3KswsnCT0VGjssXfFFYq
         jz9ZKCk/irQLqmq3uHiplQCaRQZO+nFcQ8VTV5c+AUYjCSIbQWSOmOq+yfyCHssr8PcH
         hvfNVqqHSa4H+GO0LutcfsW2L0NDLrFGOis71cAQGVmN9jl84JLjeJn81HAF0dFbRAGI
         iOy3Qo6k38q++KC1asWHiM9SpW7uGavwEuzS2WHJvOizFf05NpWCSmICc9W+MLmLo9+B
         KBpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=VkFY9VA5eLaLmOjmzlzXKbbW8wSFipjY4LA9MnWoz+4=;
        b=nF006M7t4BskWlZopP0JOTDPRuxZHVg1yFcwWld9cSWmPXjJrX9gKawvXfrVZyEHss
         MPyvpXHQyrUOmqanEwuUMUFxmEEvL+GuBJXTjf8Mj5oCWkRh0TuX8WJocRZGgjFLdnQ7
         JYPM9dDYaWnaXYRnoyITIe9zGbp7g3UsKz+FMU3kENSewl+ypyifUzrqDp+YvmyEvWM0
         U23EuQaJtkOTNRY9o8g9toien7Lfbj3R/i+ZHXdPuokfwzV5VUDl8/pEHvxBmIRQdTJD
         4RQsFArOwRAjzMIucQvgyCxJRAOsSGewK2PGD4TiBI3l5h748NzNY6alhARFf2JWpLlJ
         NhLQ==
X-Gm-Message-State: AGi0PuaE33EnqD27aCTx+cSDCZqYeJeJIA7udjOsEl4pqgywonDGs9V6
        SkaEAL6zgiJzPUHLmiahynIWL2UfvaxuIL2lT3KVNXgDShE=
X-Google-Smtp-Source: APiQypI62h1bYnzoMvA4qiCNBzqLIfYNyFcuAONTbIw8bUO3almE/Bg7DyXjizm8LqBWlaVXNjSzsLoV9HD7XR/Wlbw=
X-Received: by 2002:a2e:8752:: with SMTP id q18mr289099ljj.72.1587585145636;
 Wed, 22 Apr 2020 12:52:25 -0700 (PDT)
MIME-Version: 1.0
From:   William Dauchy <wdauchy@gmail.com>
Date:   Wed, 22 Apr 2020 21:52:11 +0200
Message-ID: <CAJ75kXYo5rYg6pLj=Qf173pwVoxd6KjLMdG-DNuR3PAYmbX7xQ@mail.gmail.com>
Subject: backport status of "net, ip_tunnel: fix interface lookup with no key"
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I found the following commit 25629fdaff2ff509dd0b3f5ff93d70a75e79e0a1
("net, ip_tunnel: fix interface lookup with no key") backported in the
following stable versions: v5.6.x, v5.5.x, v4.19.x, v4.14.x, v4.9.x,
v4.4.x.
However I cannot find it in v5.4.x yet. I checked stable queue on
netdev side (http://patchwork.ozlabs.org/bundle/davem/stable/?state=*)
but also main stable queue
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git

I was wondering whether it was an oversight or I was too hasty?

Sorry for the noise if I'm mistaken.

Best regards,
-- 
William
