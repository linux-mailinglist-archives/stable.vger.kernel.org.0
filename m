Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05FD115B2A2
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 22:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbgBLVRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 16:17:40 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35965 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbgBLVRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 16:17:39 -0500
Received: by mail-pl1-f193.google.com with SMTP id a6so1434659plm.3
        for <stable@vger.kernel.org>; Wed, 12 Feb 2020 13:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MK5SxGz0zRKTkZ22e5kVA3DOZ9q0nFCfNa4gxsGnCQE=;
        b=BybYr6OwRkevGXDa58RRkYPnSQJfnsxtjzQ8PRMBdjuoH6oIQGDwTpKps2Rfik9ORZ
         VD/FxMuAF+Mfn/d9TP++HBiHu0JXsxYx1eRjqEPcecgAvu3l2tCLiwBzcewBQkc1Y0TP
         MfST43KQXD4fF7THk0na8Uxta0AJBN4R7sf/sW104783E4bbbMEd3uIM5h1jtVJlaqzH
         7rtLCCbmYYL5YhxA7nk3i1rk8NFM/zA52rmiyj1ziqmMXN7fOf2ab2DcB9IcF3SZhSgY
         49AyszXaL0KrUyAHSYfKc2L+Jj2ZZvNWjGsVKRyKTpOfmj5lpS97s2XLgpZG3wb2Y/q0
         kNzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MK5SxGz0zRKTkZ22e5kVA3DOZ9q0nFCfNa4gxsGnCQE=;
        b=udQpthsUhEz91jDR5usHcMsTu0Xm4j5+ZQJVf4e8/KlL9kfyDHk0VpixWHWJapcI2S
         bvuf+ZotKCNX4SLn5lLmi6fsCLNMozHcJstr44qZQS8tmHz5rc8ZBUJejBezKPIg6Qaq
         A6+nM+bs8L1xl3dmrdIqDP2T8sHPWe+x0R0wjyeOs2V5QOXEtjbkYd2tAXTmNsYtt+IP
         xWP+NEegfK6k0t4Y+LKgeXH8uRsFkCX/IKGJcbuKbxMEmZ1mBOxnE6OFCwiloRmGCp8+
         ud+GnQ/CvLXhUqqhjx4mEOMLesKU3fyETmG8dggXQm2d2fPYi0F664t4Rc17GQcQrwlt
         wKEA==
X-Gm-Message-State: APjAAAVJ/BR4ijOvLH1OWymEfGxvnAjDS9D+zTLJdWy0HLw+Li4XMWNi
        QmTAFoTL+B7nBezGs1PE54m2ew==
X-Google-Smtp-Source: APXvYqzigz4EM0OaOIYfqAWucMj8jZnoisCQPum3T3EjTXHzETVL43sXIpYMlZK8r7W5iP9FMqh+Rg==
X-Received: by 2002:a17:90a:cb11:: with SMTP id z17mr1158574pjt.122.1581542259114;
        Wed, 12 Feb 2020 13:17:39 -0800 (PST)
Received: from debian ([27.57.24.230])
        by smtp.gmail.com with ESMTPSA id l69sm64890pgd.1.2020.02.12.13.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 13:17:38 -0800 (PST)
Date:   Thu, 13 Feb 2020 02:47:30 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.4 000/309] 5.4.19-stable review
Message-ID: <20200212211730.GA36144@debian>
References: <20200210122406.106356946@linuxfoundation.org>
 <20200212073531.GA5184@debian>
 <20200212133037.GA1791775@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212133037.GA1791775@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 12, 2020 at 05:30:37AM -0800, Greg Kroah-Hartman wrote:
> On Wed, Feb 12, 2020 at 01:05:31PM +0530, Jeffrin Jose wrote:
> > On Mon, Feb 10, 2020 at 04:29:16AM -0800, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.19 release.
> > > There are 309 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 12 Feb 2020 12:18:57 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.19-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > 
> > hello ,
> > 
> > compiled and booted 5.4.19-rc1+ . No new error according to "sudo dmesg -l err"
> 
> Thanks for testing, there shouldn't be a need to run 'sudo' for that
> dmesg command :)
> 
> greg k-h

hello,

   thanks for helping me improve.
   i had "CONFIG_SECURITY_DMESG_RESTRICT=y"
   i did related to "sudo sysctl kernel.dmesg_restrict=0"
   now dmesg without sudo is working.

--
software engineer
rajagiri school of engineering and technology
