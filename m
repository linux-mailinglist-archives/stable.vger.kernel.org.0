Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 036BF15CE8D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 00:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgBMXRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 18:17:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbgBMXRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 18:17:13 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C53D2082F;
        Thu, 13 Feb 2020 23:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581635833;
        bh=9BFksy91a775VSD9NdGjMXAGbW9PDXIG+9cxZg+b95s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p6gRYqf6ur5aDrjWN27gT37hIo3Fzop8EuMG1m0qJR9AJV5GbDpc69qc/vfON8q2w
         5eh/rZFDacb70HxoGTMTuS65fW1tcmPPgUrmdBwTYoHCMKZl6xa1fnkozhwR9vSknZ
         k4H/CevBe78zcmD+Kyzq6oYfcAE6Og15mxBzcKSo=
Date:   Thu, 13 Feb 2020 15:17:12 -0800
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
Subject: Re: [PATCH 4.4 00/91] 4.4.214-stable review
Message-ID: <20200213231712.GA3925201@kroah.com>
References: <20200213151821.384445454@linuxfoundation.org>
 <TYAPR01MB2285DD1197799842E72C26B1B71A0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB2285DD1197799842E72C26B1B71A0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 04:57:32PM +0000, Chris Paterson wrote:
> Hi Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 13 February 2020 15:19
> > 
> > This is the start of the stable review cycle for the 4.4.214 release.
> > There are 91 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> No issues seen for CIP configs.
> 
> Build logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/117668767
> Pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/blob/ba32334b/trees/linux-4.4.y.yml

Great, thanks for testing 2 of these and letting me know.

greg k-h
