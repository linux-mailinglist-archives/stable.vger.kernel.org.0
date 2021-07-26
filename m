Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2343D547E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 09:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhGZHBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 03:01:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231891AbhGZHBv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 03:01:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0519B60F4B;
        Mon, 26 Jul 2021 07:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627285339;
        bh=XjP9T5SVR1hGaZZ0H+ebVpsXTLvb5MBnUjqB6IlN/uA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J2a/NC1ztTLYavuEUKDodS1y86p8UfxaYEjIK3eMPGsuS/lvRtHWJDBNxekHTYJBz
         Cs457F6BGLVSdYtG2KlhYFjco+DpaOR6oEsCk2BqYpvCefQzrdVb/qqjacEMITocz3
         8TVyxPiCMx7lEwGT595SWimQkQfq/XXd5tIpmprE=
Date:   Mon, 26 Jul 2021 09:42:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     syphyr <syphyr@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Additional CVE-2021-3491 commit for 5.10 LTS
Message-ID: <YP5nVKfALwRBdUzT@kroah.com>
References: <fe4dad2e-c4b9-1a62-ea61-e0364b5300dc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe4dad2e-c4b9-1a62-ea61-e0364b5300dc@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 25, 2021 at 08:13:48PM +0200, syphyr wrote:
> I would like to mention that there is an additional commit required for
> CVE-2021-3491 on 5.10 LTS.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.14-rc2&id=d238692b4b9f2c36e35af4c6e6f6da36184aeb3e

Already all queued up for the next round of kernels, thanks!

greg k-h
