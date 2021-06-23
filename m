Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8D13B1D53
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 17:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhFWPPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 11:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhFWPPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 11:15:03 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FD3C061574;
        Wed, 23 Jun 2021 08:12:45 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id g21so845713pfc.11;
        Wed, 23 Jun 2021 08:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=wnhbXxHraLaC8TefgPDC+qQd7KIYTELFweoZS4SUhy0=;
        b=cP9+Bnv9X/RUwcBBLodk6HrdfAq7W8xUm9jF2y9HxXigTtOrU1sWXPymJ5bs89RacO
         jBzLD7af2mpTkEnBGbiL+tquNd29+ZucE97dUa/wg5x9yxh/2Q2DhA3nNUgguCojeC+2
         ye5pA/A7+/ASg0WRcz8Y+wkI18xq3foKgWgm+I/8I71slXidjjF1kdbj3gbBQ7h259md
         jrP+lc963A8qA9pBqiG6o26eQEBGf/35bFlUG0b2nu50df7PXXXvIm6NMJg6PVM1nMXN
         W3yraZ7G9a3nAZMyPTKE5vegJ+B0wxMG6EzrK04lpdptXxhgKMNhwJrFOZF/nttItP7O
         2GiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=wnhbXxHraLaC8TefgPDC+qQd7KIYTELFweoZS4SUhy0=;
        b=CyVbBRzVM6YGR8lZK4OZELheDUqV4ibjqQ0VMjC/ZgB61UMYOiooB86mGOqv3xjzix
         FX7k1Z1z65OH0RjXgjc6xCo++z/63/zlZ7oeiZAdlQhA5bZI23jG4BJ3OfzHMtnmFKYJ
         9f99YGmBmqkBWynzXKdEhnJ0kq95gzkekAaSv8UoF0jdVSBjRg/P56XIjqeptvGvuX+P
         jFxscjDHPEDaCZJLdGRMrVso5K8Nfndb4jMzeFTJXzGz7oj2v6gu19Pq12bRQzPCLPIs
         AELqeqmtaRoXYiZFQulo7aAwGzdgu5ETUA40Oe6kZ+j6YsCIZu4Sgb6EzWp5JeQXvfIA
         z3zw==
X-Gm-Message-State: AOAM532SQU0TGtC2lFEH62mHDxabUUHKZBi1TekdHelPxjpq4/Uq3g6Y
        wLPkKkbIjrF8h9Y7Bbv9nT8JgtZNni4fcJq5Qxc=
X-Google-Smtp-Source: ABdhPJyW3C19YcI6JBUyZ6Tuo39lmC+yIi5EjMEHx+N+pda0aHhEcxXaVCYwaWzYfkc/dFXamiQO2Q==
X-Received: by 2002:aa7:9252:0:b029:2ae:bde3:621f with SMTP id 18-20020aa792520000b02902aebde3621fmr272079pfp.18.1624461164822;
        Wed, 23 Jun 2021 08:12:44 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id o7sm235740pgs.45.2021.06.23.08.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 08:12:44 -0700 (PDT)
Message-ID: <60d34f6c.1c69fb81.3314.0aa0@mx.google.com>
Date:   Wed, 23 Jun 2021 08:12:44 -0700 (PDT)
X-Google-Original-Date: Wed, 23 Jun 2021 15:12:42 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
Subject: RE: [PATCH 5.12 000/178] 5.12.13-rc1 review
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

On Mon, 21 Jun 2021 18:13:34 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.13 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.13-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

