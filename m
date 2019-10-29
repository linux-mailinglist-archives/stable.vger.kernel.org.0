Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F075EE8F10
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 19:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731001AbfJ2SM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 14:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730830AbfJ2SM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 14:12:28 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3D1C20830;
        Tue, 29 Oct 2019 18:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572372746;
        bh=//hHLrLuHCFCNZmZeJxLLNEYHGxHBHQ94GJJ1qN+ZQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XdiWRYSGefUGeE+ILUkeri5BmVmf+mbOKYUMtTTCojoxUktFincUxxYSfIoAat9qS
         KvnQvql026zBvScr4s+MPOzOwmHAeZDFaMe1nDBU7MuIm2Onz/tsr33dMW1h8mYjQ/
         4xzyXw2w57xP1V19K4WM3XhTQMJMBLJmg7SdiADE=
Date:   Tue, 29 Oct 2019 19:12:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Deepa Dinamani <deepa.kernel@gmail.com>
Cc:     Murphy Zhou <xzhou@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Linux Stable maillist <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Eryu Guan <guaneryu@gmail.com>,
        CKI Project <cki-project@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.3.8-rc2-96dab43.cki (stable)
Message-ID: <20191029181223.GB587491@kroah.com>
References: <cki.42EF9B43EC.BJO3Y6IXAB@redhat.com>
 <CA+G9fYvhBRweWheZjLqOMrm_cTAxNvexGuk16w9FCt12+V1tpg@mail.gmail.com>
 <20191029073318.c33ocl76zsgnx2y5@xzhoux.usersys.redhat.com>
 <20191029080855.GA512708@kroah.com>
 <20191029091126.ijvixns6fe3dzte3@xzhoux.usersys.redhat.com>
 <20191029092158.GA582092@kroah.com>
 <20191029124029.yygp2yetcjst4s6p@xzhoux.usersys.redhat.com>
 <CABeXuvpPQugDd9BOwtfKjmT+H+-mpeE83UOZKTLJTTZZ6DeHrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeXuvpPQugDd9BOwtfKjmT+H+-mpeE83UOZKTLJTTZZ6DeHrQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 07:57:05AM -0700, Deepa Dinamani wrote:
> The test is expected to fail on all kernels without the series.
> 
> The series is a bugfix in the sense that vfs is no longer allowed to
> set timestamps that filesystems have no way of supporting.
> There have been a couple of fixes after the series also.
> 
> We can either disable the test or include the series for stable kernels.

I don't see adding this series for the stable kernels, it does not make
sense.

thanks,

greg k-h
