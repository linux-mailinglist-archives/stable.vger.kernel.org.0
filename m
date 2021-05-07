Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFDE376AEC
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 21:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhEGT7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 15:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhEGT7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 15:59:34 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4CBC061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 12:58:32 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id s25so13079614lji.0
        for <stable@vger.kernel.org>; Fri, 07 May 2021 12:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=s9w3/bSqpoDdZ2CYSnfBT6ojJMbSFzserQsg6/RYvR8=;
        b=A4IeEXu1SOSLw75F5+VmBFxc3ESgOuN3y15u7yItEUkduxeorU21LsyXTWWBejK4FR
         bwsu/z1SBrnVId9Eo/ilIgJ7QO2g7apj+Ws3UYexWx/nVg9B67/UAPHGFDbTWP4QzBKz
         Pqg8RevLMHCuOjvnvcBs2eCXJm8brgDgI2SEPUKXMi5e5kD/7HZVYoLMJ+tsBX72flS+
         tGZfsEaYb1vDjjwgEulb5pYJAzi6D44GGerZpURSTX6TK56MRx7mP1GDMMc2HO4z27ez
         3glrxGDLfPsxFsneBG5zil3xBBWxe3MjjYCQ0AQbDlUaSpty+BZjSYajc61tPpJmonC6
         5P4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=s9w3/bSqpoDdZ2CYSnfBT6ojJMbSFzserQsg6/RYvR8=;
        b=LoBgEhg6UQGhJoWWa7RFRvoLpcwSz/z5hUQwLrIFfu5xWs0woTcQ35YfUk4rqn2r9z
         kknUy0SRDB89MokftLoUl64gfMKkRZIZnEFQzz7rK2hCHePCzX8l2JLWNqXXDIFdkntK
         B1YvbfFTstb/07yHUNDP63ArfhgesPTOqoHS6+ww9ocD+fJ19wfJNbKEa1t+hjFHEsjc
         DOeVY2hfxfjJdnXXX1SqBiJvfabul4e4YadVmQBlq9pisrfgQsjT1D8UQK+wsE13wT7R
         B1PVevjVaTB0SmEDnmc1ervWif9l9LJIjTdYQB+oEqh+y503WTV3oSuZKKMA4S29cYMT
         ef2A==
X-Gm-Message-State: AOAM531ar2I+dYLBI5cTAVuL9RPQpuQELUVKDamg39TUYA5sce1EjS89
        KvC/ZNjJvsB9XYFs5GGF7gqArFxcFMayNmIJzz7JmbvUQnc=
X-Google-Smtp-Source: ABdhPJweirA1x3YVhf7Ala7ucFjhXt+yO7BYZwQMsHDMvAU2CeH1ptrNtZy9XZzWHMUD8X28ScfEdL7cgGs80XBs8+I=
X-Received: by 2002:a2e:8ec5:: with SMTP id e5mr9213624ljl.262.1620417511009;
 Fri, 07 May 2021 12:58:31 -0700 (PDT)
MIME-Version: 1.0
From:   Andrey Zhizhikin <andrey.z@gmail.com>
Date:   Fri, 7 May 2021 21:58:19 +0200
Message-ID: <CAHtQpK6OD1yVkStsmP1d736ipHzk-ycEHQHHNnJEjxjAUQ-eFw@mail.gmail.com>
Subject: Stable inclusion request (GCC11-related fixes)
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

Can you please pick up following patches to respective releases from [master]:
82e5d8cc768b ("security: commoncap: fix -Wstringop-overread warning")
# 4.14.y, 4.19.y, 5.4.y, 5.10.y
e7c6e405e171 ("Fix misc new gcc warnings") # 4.19.y, 5.4.y, 5.10.y

They do solve build warnings with GCC11.

Thanks a lot!

-- 
Regards,
Andrey.
