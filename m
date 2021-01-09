Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0312F0352
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 21:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbhAIUH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 15:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbhAIUH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 15:07:27 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC26C061786
        for <stable@vger.kernel.org>; Sat,  9 Jan 2021 12:06:47 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id b5so8121428pjl.0
        for <stable@vger.kernel.org>; Sat, 09 Jan 2021 12:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=XGAMMZsbYCUGjn/7vUQpuXOzkGrvX40U8YFaopPsXG4=;
        b=NnbjUOyUqqyo/+stMOmwIQUumLBt5z4LgD3Kjg90wDKapOW1V/6IptEc485gunpOP0
         ZXYquPmRtADPkihfd8OXJkkcXFMXWR0zDmaryhe3oN7r10IpcKB6vlztn25+WzPj8oJq
         PI/m4DlD+Mbzw3aX2mubno1yTtObf0dp4FJPvzyELXYNXrVovprYUiZ7ECv1geXQS53J
         rJIbrq/wKyIgPF9ucPb4Y6vMnGjl+UgMq/MBmbubEZ0yjxBhmgo3k6Jle6/HY2TPCE7x
         +AV+T2Tnq3swbGrYyk/YWckQHP0solhvgCH5F5lvUKiA6BLS6MvhQ3EVEi4PavjOyh3m
         +FWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=XGAMMZsbYCUGjn/7vUQpuXOzkGrvX40U8YFaopPsXG4=;
        b=kS86Hs7IvwxRC79YRrt6cYmGh4a6PIM5ipG8+TwD29s47ZLWpx7NWzDm7XLaiUofu0
         T4HRwb5ekoH31Q3V9RmYm3zprREUoFrqodSUfKaiaTA8/6pm00VtqRDIJMQHJRZ58sZx
         S6YU9pnCwFGd1FPFMx4kggCVXcbf/yCJ/IKIoVnV6vmLuixCKNEmwnqbvkcoBbmJ8G8o
         j2f9SSW4whMnzRYIgZn9cENGDmdhLtj64Qi+L1mOJkqO+0hT03BBIwwIjgBah4NNG74q
         MxTWjDI1kcU8aBwhc+/PkP4tyYxVgaKTwVHMrxuWoLNfyskjDFt8rcNJnoNuAS34qu9g
         ZDHQ==
X-Gm-Message-State: AOAM533bmYXmzTcIuEz5WcUu6t0gv4JDHCwhU5koKIHB4R6b8xTQ4wRl
        itMq/eySDqb0wfIvRbNlm7FEWxqeV2Xkzg==
X-Google-Smtp-Source: ABdhPJw8ul7uGaK/ShttnYpw/8l0bmral7XTFTG1bY3sqit/ihVH+QHYeOFAW6dbFInyyH+jA31w5Q==
X-Received: by 2002:a17:902:7c8f:b029:dc:8e14:95a8 with SMTP id y15-20020a1709027c8fb02900dc8e1495a8mr12927757pll.52.1610222806851;
        Sat, 09 Jan 2021 12:06:46 -0800 (PST)
Received: from ?IPv6:fd01:5ca1:ab1e:8a2a:842a:94e2:b7e6:9100? ([2a09:bac0:20::815:825])
        by smtp.gmail.com with ESMTPSA id w19sm13417873pgf.23.2021.01.09.12.06.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 12:06:46 -0800 (PST)
To:     stable@vger.kernel.org
From:   syphyr <syphyr@gmail.com>
Subject: Bluetooth Fix for 5.4 LTS
Message-ID: <6c91a7ed-a2a0-f74c-5c0c-c7abe0f783c1@gmail.com>
Date:   Sat, 9 Jan 2021 21:06:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,


I would like to report that bluetooth has started crashing with 5.4.87 
kernel release because of this commit: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.4.88&id=18e1101b0ee9b9f2483e0efd0dcf3763b3915026. 
The fix is this: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.11-rc2&id=5c3b5796866f85354a5ce76a28f8ffba0dcefc7e 



Best Regards.

