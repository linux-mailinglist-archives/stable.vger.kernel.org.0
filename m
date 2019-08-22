Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE379A3FC
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 01:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbfHVXj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 19:39:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727081AbfHVXj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 19:39:29 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03E1F21848;
        Thu, 22 Aug 2019 23:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566517168;
        bh=h97KeFoQ4IPkGOvpz+652NWjuwd55+sTOa6TbqPPsyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iJmiz002uBbMMQRNfM01EykB0x3a4wDpvzA21BOkHosgNB8FD54MsPXZmeMD49hwD
         VChtOLcIg4QNpKhllWa99pW6ITIwvsLvLUTuuljZTbnAQ/ZTGDaCBWAvqY31miMv+Q
         oevnHBn7Q/5qd7/gSd6/DqaO0oTjQk7XN0J/sIE4=
Date:   Thu, 22 Aug 2019 16:39:27 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kevin Hilman <khilman@baylibre.com>
Cc:     "kernelci.org bot" <bot@kernelci.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/71] 4.14.140-stable review
Message-ID: <20190822233927.GC24034@kroah.com>
References: <20190822171726.131957995@linuxfoundation.org>
 <5d5f064d.1c69fb81.ab35c.8cfd@mx.google.com>
 <7h8srk238x.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7h8srk238x.fsf@baylibre.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 22, 2019 at 04:23:58PM -0700, Kevin Hilman wrote:
> "kernelci.org bot" <bot@kernelci.org> writes:
> 
> > stable-rc/linux-4.14.y boot: 124 boots: 2 failed, 106 passed with 16 offline (v4.14.139-72-g6c641edcbe64)
> 
> TL;DR;  All is well.

Thanks for the interpretation of these, that helped a lot.  Glad nothing
is broken :)

greg k-h
