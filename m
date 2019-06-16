Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA5B474E6
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 16:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfFPOCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 10:02:01 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:40054 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbfFPOCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jun 2019 10:02:01 -0400
Received: by mail-pf1-f171.google.com with SMTP id p184so4191977pfp.7
        for <stable@vger.kernel.org>; Sun, 16 Jun 2019 07:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=+9SY9UOrDIgSOiRuzYvNv9Ju+E2lb6ombWx2jui4xSo=;
        b=kznWOIYCpwvnC8buTa7Qqx4mrfx2f2AATurC2AYDxNELO9pkt4lshkwY9KaKA4bPw8
         NVTT//RwVPK4m4V7SdgvDsIkOGhXsYFJ5DQuX71dC14/rdoqbI6J9APJjmomf408WyXV
         5999ftF2MPF9G77hW9EGixfFartnhiivohz05p5oZbwIVNMxkZ4PWMNlL8mtu+hE9kBn
         3oU7vNOlxc8FkEBlj2DyrSgflvbZ3EjX/FpSxfwTZT56YgqOm3jxdYUIuF67h3sy7NN5
         UAzyGCAWqPHc1ofE/K4wx9CkOOwV7H/V2Cv9I6zf4hFXNWjuAtH8GafVbsu+AqT8bzV4
         4LNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=+9SY9UOrDIgSOiRuzYvNv9Ju+E2lb6ombWx2jui4xSo=;
        b=JWopKilNfoMfXbVqrfukTR99aS+y8E05kTETTszJPqmw3Bdu8/9s4TTJDVy0ZooAJ9
         ckE0cTOXiTF4Q94Cy/1Y2qq3kty32TDSOP5MFZnczSh3i++KWgHZNhoUFc9BWjVACAx2
         qy13Rne1zP58aAUmEj1b9DnZjxpclQmTdzQ/ObFqaLzdTP4wUvHPdD+vdD1AdepcjUb0
         BQfMTgt8jlDGB+zLMcaTqlcPA1aZrpYQ98GUy9pLsF/eqAVAbyA7Ro99GIxrXMfP+6//
         MzN5Md1m9pKaay0khcgLlRYANa0mhTI87J+d3daY05i5oTSn2dFb9VYygq237ZWS4iKY
         pqsw==
X-Gm-Message-State: APjAAAXdOwwFWQ7VFQF+xpLKOYvfdRz9Y2f6SkVpUs5LmrsbEnm7P1Z4
        CGnwnz8Eb04pwobwTUre13U=
X-Google-Smtp-Source: APXvYqx+b3NLBe9C2gxl5QSxqlfLG86QUWzWc9gx8UXwmSUn15uVgnKd/0ID7WamvxeZQC1ttR/2GA==
X-Received: by 2002:a63:d006:: with SMTP id z6mr34063645pgf.364.1560693720498;
        Sun, 16 Jun 2019 07:02:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 30sm10459347pjk.17.2019.06.16.07.01.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jun 2019 07:01:59 -0700 (PDT)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Build failure in v4.4.y-queue
Message-ID: <88e25ca4-9e77-74b7-4466-2477cb07ce20@roeck-us.net>
Date:   Sun, 16 Jun 2019 07:01:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Building um:defconfig ... failed
--------------
Error log:
kernel/time/Kconfig:155:warning: range is invalid
/opt/buildbot/slave/stable-queue-4.4/build/arch/um/kernel/time.c:59:14: error: initializer element is not constant
   .cpumask  = cpu_possible_mask,

Caused by commit 502482cde8ab ("uml: fix a boot splat wrt use of cpu_all_mask"),
which fixes a problem which does not exist in v4.4.y.

Guenter
