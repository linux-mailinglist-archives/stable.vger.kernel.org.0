Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01C63A68A1
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 16:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhFNOEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 10:04:47 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:39918 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbhFNOEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 10:04:46 -0400
Received: by mail-pl1-f172.google.com with SMTP id v11so6606029ply.6;
        Mon, 14 Jun 2021 07:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=s4p3dw7oIfdQoFT07HVLF2BIw5Xk5aaqZSJ+5CsRAH8=;
        b=tij0bsvbnbllhsjEvjQapbZcIKGkodJud3kAUj35bR8BpmF1Q/Yq6gzLlXVnBdrizd
         0WP3uVrYGnjuDYqn9KPDAdXnM+Ow5gJSYROoiK2MwHI/6YMaAju3n1RhEEkJaPP2x1Ar
         QrxeJ9liRXibkdPaa5V2lEm052dzUIZBaHVx0F2O7Nj0l4TLw1TgO6auglbegquJ+vgB
         eTF4B/qWfKuP4hgUt5JoBbaowKeJXuHVQ5RhXci0KS5vEQVwMS1+1bK5WTQOXzF6RwJ4
         kPXX8UQyiWjAcOpmGvGQuiEPCud6UsoAbLNlhj9jXYFT4KBRSs7bTXZx7FtnC4XPrRiU
         86EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=s4p3dw7oIfdQoFT07HVLF2BIw5Xk5aaqZSJ+5CsRAH8=;
        b=TjApuHBSSXz74EvcGv+kAB+JsgpbeN7q0r6wbU2AI7HRTO/W2R4QqPWzhkKhQ01Ych
         obvVH7GQxSuM9Z72cc7G/uYcY0x2IA9WjZ473p2ryMJJXp8IAsxbsfHQggzR8PdHl6fn
         maC2Bg6LLu7RuaVEmEJ4EjJRMIuHfJQyZsVrANq/whqo7m40v9O1GBKRH6+SrGokDfcM
         5wNjDBkFvPSu2cxrOjjVok2A/YSmwonwPHO/35WSrxGoLGl7+/DhchWAGytj0KsiULS8
         GTGGEp7gcD8kEA+eLo6MUqyltYSWpi1VVjCHiIg5KxrwFlqFNQdz1m5iWYzchfYifvb/
         WwAQ==
X-Gm-Message-State: AOAM532yKs7WpGxPE+Q1boFlPh4IrY/kKenxpkgKBY/dbJhKObqcuBXl
        Kl/BDDuRgE6zGuY8EM3dNt3M8NHROQ1Rifv+xkg=
X-Google-Smtp-Source: ABdhPJxHhqfrNxrAmYejLohWEqvmGIR/4Q6zI9EwAT0Mm+oNEmZIB5sYp6ecXTfiKcS1915dW8iFHQ==
X-Received: by 2002:a17:90a:31c4:: with SMTP id j4mr24063049pjf.105.1623679288403;
        Mon, 14 Jun 2021 07:01:28 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id t1sm12584258pjs.20.2021.06.14.07.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 07:01:27 -0700 (PDT)
Message-ID: <60c76137.1c69fb81.65d98.3853@mx.google.com>
Date:   Mon, 14 Jun 2021 07:01:27 -0700 (PDT)
X-Google-Original-Date: Mon, 14 Jun 2021 14:01:26 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/131] 5.10.44-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Jun 2021 12:26:01 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.44 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.44-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.44-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

