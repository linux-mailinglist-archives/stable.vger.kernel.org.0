Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D5D13F70
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 14:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfEEMiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 08:38:09 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36218 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727593AbfEEMiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 08:38:08 -0400
Received: by mail-io1-f66.google.com with SMTP id d19so8938394ioc.3
        for <stable@vger.kernel.org>; Sun, 05 May 2019 05:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Env16Kjh/S/tPnSWgndkg5+56faTqmTyePlsgJmP09M=;
        b=XP/vtf0Dlv9BGu3OP4nffNiWlGm7z/cvckO4+kX5ZKF4IJtf+OZcnEP/FUYEcmRX7d
         4s3WoTpZ011CUs78Bw4H3hVnCYaN0cMqIK9GUKJiXQ/NCIOn1j7q7xPAVm9WKhUPWYoH
         8+z2CKe5dnlhNvHn4iO6OBRIBwbllA68q8mtBqbBNcL6t+bO1AP0caZ6crIyMDhV2kgI
         /Dnor3a6Ey3sJUb6EDWUYZIODSn/OLUcRAq0FXP3hPqLL8FMkk7QQuix7RMbYRkl55nC
         md0Bwh3jJkaWpJ5N6+AqprdXmeRBgrDdmJTRtHGxUDQKN4oBFx2lLk4fMm2TxLJYG2H5
         YIzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=Env16Kjh/S/tPnSWgndkg5+56faTqmTyePlsgJmP09M=;
        b=g/rvZd0Uu1roTduWbYv7ewhJc9Ziy1exL8tIpZ6honnnqlqzQEpNsdSsWuZL95ArLN
         UMt9QOr/5ohKDWisLxfM8vQETTdpYBsjrWtybgKFTol/5oLfA+rFCQ5ttFotiUpw7G9n
         KiPB85+60+71/f3shLLeIMfQjyc0JZo0NowPEGbOJnG+GrCKLETd9O5YaXaKL1hyjBUu
         REkUNc3tlXaBOGNtDAfIIawYK3/jDPzQ7oZr6ClNfsSZCtQWcNvNIz+2yodyaFsxTfvN
         +OLdPBsaGtLuu1E+rGjdIh7qVMJbr+13QmE2vEo4qJksD+xCts/riP7vpwpyiYKt8s2x
         Wg1g==
X-Gm-Message-State: APjAAAUUFkB6qKU0PUNK0YycwbZZlUeyn/a8XF8DRm1dmNxnABLCgLhM
        JUrn7IDcWf2y6u6dMCI49da6rA==
X-Google-Smtp-Source: APXvYqyNcDuss+Z4/v3Efpyj8txBV/fjSy5ttytvA5R44fIHq2k5zf1CuBdHu8UAkV3gXrzTIMKDXA==
X-Received: by 2002:a6b:b745:: with SMTP id h66mr8530702iof.107.1557059887916;
        Sun, 05 May 2019 05:38:07 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id n138sm3480757itb.32.2019.05.05.05.38.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 May 2019 05:38:06 -0700 (PDT)
Date:   Sun, 5 May 2019 07:38:05 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/23] 4.19.40-stable review
Message-ID: <20190505123805.u7ivqoof777b6uqb@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Shuah Khan <shuah@kernel.org>,
        patches@kernelci.org, Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
References: <20190504102451.512405835@linuxfoundation.org>
 <20190505030044.q3dlgd5bhfx5txmf@xps.therub.org>
 <20190505070854.GA3895@kroah.com>
 <CA+G9fYv668HB5nZSn_drMd5cLhfH7GP0NxDsF88wtp3MUAMimA@mail.gmail.com>
 <20190505090236.GA24937@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190505090236.GA24937@kroah.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 05, 2019 at 11:02:36AM +0200, Greg Kroah-Hartman wrote:
> On Sun, May 05, 2019 at 02:23:22PM +0530, Naresh Kamboju wrote:
> > On Sun, 5 May 2019 at 12:38, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Sat, May 04, 2019 at 10:00:44PM -0500, Dan Rue wrote:
> > > > On Sat, May 04, 2019 at 12:25:02PM +0200, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 4.19.40 release.
> > > > > There are 23 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Mon 06 May 2019 10:24:19 AM UTC.
> > > > > Anything received after that time might be too late.
> > > >
> > > >
> > > > Results from Linaro’s test farm.
> > > > Regressions detected.
> > >
> > > Really?  Where?
> > 
> > Not really.
> > selftest: net: msg_zerocopy.sh is an intermittent failure on qemu_i386 device.
> 
> Is that a test problem, or a qemu problem?
> 
> > We could ignore this failure as known issues.
> 
> It wasn't listed in the report, or did I miss it?

It needs further investigation, but it's unrelated to this RC. It's an
intermittent failure that we see sometimes but only ever on qemu. With
the amount of tests that we run, this is common - our process is to
investigate the failure and determine if the failure is a regression or
not. In this case, I determined that it was not a real regression, but I
did not run the right command to generate the report accordingly.

No regressions on arm64, arm, x86_64, and i386.

Dan

