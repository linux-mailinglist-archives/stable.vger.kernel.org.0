Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC15018195E
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 14:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbgCKNNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 09:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729331AbgCKNNp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 09:13:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DF8422464;
        Wed, 11 Mar 2020 13:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583932423;
        bh=nSTq/Xtmzmfw2ovxtHjJFVetZe+Zw11xu04yrvqOTqA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e5tHNsMFFZ1WpV7VRriJJUNdOl/dVVMnbkeOXOeDN0mtEobzQC6pDoSyaflqWgRKY
         CwzbNwSNCnjUEmDkCVm076H0o56KG45mozccRBn75Xva87c6OA5GmzVr+AgxjQkfw/
         iVvqY85EiOrgyQkx/30HBogKuNJ+vChFif72zDAk=
Date:   Wed, 11 Mar 2020 14:13:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/86] 4.19.109-stable review
Message-ID: <20200311131341.GB3858095@kroah.com>
References: <20200310124530.808338541@linuxfoundation.org>
 <OSBPR01MB228067017410645AC3A78939B7FC0@OSBPR01MB2280.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSBPR01MB228067017410645AC3A78939B7FC0@OSBPR01MB2280.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 10:56:06AM +0000, Chris Paterson wrote:
> Hello Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 10 March 2020 12:44
> > 
> > This is the start of the stable review cycle for the 4.19.109 release.
> > There are 86 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> No build/test issues seen for CIP configs for Linux 4.19.109-rc1 (624c124960e8).
> (Okay, there is a boot issue with the arm multi_v7_defconfig, but I'm pretty sure that's an issue my end that's been around for a couple of weeks now)
> 
> Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/124879010
> GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/blob/master/trees/linux-4.19.y.yml

Thanks for testing 2 of these and letting me know.

If you figure out the boot issue, please let us know.

greg k-h
