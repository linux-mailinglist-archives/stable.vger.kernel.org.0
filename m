Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD07CC626
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 00:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfJDW5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 18:57:42 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32858 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDW5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 18:57:42 -0400
Received: by mail-pl1-f195.google.com with SMTP id d22so3816411pls.0;
        Fri, 04 Oct 2019 15:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YZKZa5ifFKVqOTLkagrQ3Lr8Mm9pJ11iTiBWMihxuqU=;
        b=R1K5/MK3bWFwOxIRy4oqum/qU20aa2jePSfA1/Cz0fbHaDyrFlYRFIAlZvtNd6smKG
         icp1uBjD0kA40hLhn6f5LPBIYswUPgBM15taU5/J3nCgnFp/GR9lx5DFhH3StrrTQvB6
         WyL6CcBRQhEmyH6zjOOVcPgQt82Z18x9u5wSMe+McFRBTa7IblSpuZffAH3Tdexchi9v
         WguktBaWqAkx2ZWQyDz8p7udKXRBaXoq4W3iCe2LWpqTKaJ+YE/5Yk6W8wuOKF9p9H8d
         igb4dyZaMO2HvYfS4/+td+CdU5RKg21ztiU3Mif903fQ2LXvNIuxoLyBvBQBSj/AmqjG
         m0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=YZKZa5ifFKVqOTLkagrQ3Lr8Mm9pJ11iTiBWMihxuqU=;
        b=QMmIuyXfXWwsyHkRJL+dLppTujKhuN53Rt8PL2EFCAFWBHZHksipp9k04yRdhW5/Tq
         sgO+tlvfI8Qax9FOzIjn3SajYcOMNvLCzW4STvePXYN65g+AbFAtU9UY0RJXwO0SO+hy
         pjWGRii9qOF+uO6yZZAcNraObVfVJ18ElP3d3x+07ERBJlL9Zv+2uotYpsRJ8xjMXE3z
         YxMR5nwfhneL/so9aZB30VsokzApoWGzzE8zdhIfV6eqvsjgid3Zqf+phjOH3xxuTG3S
         YGpsT6MxLB56E7yJtb7EtcyZ0OCZ+WHW1oACS3s1lE/2k4J8SLN0Fl/TtkNhvSNIJHSq
         S7Xg==
X-Gm-Message-State: APjAAAVeb8eyS2pzIQcdXyr2PevoYqwxYZsqOkju70NfFkwmDFBvEQct
        U9Wclk8Uv6upQaBO1F4hEao=
X-Google-Smtp-Source: APXvYqztsZTVTv5ZM/qAVCGclrdxDrFO6uHlYeLgQK/v+Oti5YrFRc1iG8wYQpAgyld/FvWeEQRm8w==
X-Received: by 2002:a17:902:7401:: with SMTP id g1mr17609640pll.20.1570229861452;
        Fri, 04 Oct 2019 15:57:41 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b3sm7964046pfd.125.2019.10.04.15.57.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 04 Oct 2019 15:57:40 -0700 (PDT)
Date:   Fri, 4 Oct 2019 15:57:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/185] 4.14.147-stable review
Message-ID: <20191004225740.GC14687@roeck-us.net>
References: <20191003154437.541662648@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 05:51:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.147 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter
