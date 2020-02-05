Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8963B153338
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 15:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgBEOmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 09:42:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgBEOmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 09:42:35 -0500
Received: from localhost (unknown [212.187.182.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03A7E2082E;
        Wed,  5 Feb 2020 14:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580913754;
        bh=goRHpqEzVWgkqM25Lpk2akGfuhi2SOTuDM5xHmMAyuQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WXZZAttR7PfFWVWbKmWdaMDPyw3zKo2M+M7y71YhqVGGkBqRNWArDs4aEIXkF2DPV
         2V99cMxHSjYsmhos7BdZ9MGtR0E3lOe0nuHhvmDTjQ7RcGuNOO2RRe5sX8pIJuzDbO
         LVsRHSbMA3xDgyodVFRcdCGk1depdBDKdVAaEW5Q=
Date:   Wed, 5 Feb 2020 14:42:32 +0000
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/70] 4.19.102-stable review
Message-ID: <20200205144232.GA1227283@kroah.com>
References: <20200203161912.158976871@linuxfoundation.org>
 <20200204123726.GA6903@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200204123726.GA6903@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 01:37:27PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.102 release.
> > There are 70 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.102-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> 
> ;; This buffer is for text that is not saved, and for Lisp evaluation.
> ;; To create a file, visit it with C-x C-f and enter text in its buffer.

:)

> I see different lists in git and on the lists. Extra on list:
> 
> 20434 O   Greg Kroah ├─>[PATCH 4.19 01/70] vfs: fix do_last() regression
> 20435 O   Greg Kroah ├─>[PATCH 4.19 02/70] x86/resctrl: Fix use-after-free when deleting resource
> 20436 O   Greg Kroah ├─>[PATCH 4.19 03/70] x86/resctrl: Fix use-after-free due to inaccurate refco
> 
> Extra in git:
> 
>  | b220e4852d0a d55966c4279b o | btrfs: do not zero f_bavail if we have availab
> le space
>  | e3dce09f7f99 c3314a74f86d   | perf report: Fix no libunwind compiled warning
>  break s390 issue
>  | 39dc8d352a93 dfe9aa23cab7 o | mm/migrate.c: also overwrite error when it is bigger than zero

Yeah, Sasha added stuff at the last minute, this was a "tough" round,
sorry...

> Automatic testing did not find any errors in 4.19.102-rc2:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/114683672
> 
> (Hmm. I see some problems in 4.4.213-rc2, let me investigate.)

Great, thanks!

greg k-h
