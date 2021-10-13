Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6ED42BA18
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 10:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhJMI0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 04:26:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229670AbhJMI0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 04:26:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A478F604DC;
        Wed, 13 Oct 2021 08:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634113437;
        bh=l/I1xBKb06G8EyZ8fd0FztbOm0d3chs8uPbfdbSOweU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F6ObPl/2Fq4AD+0UtvIT1T0JK36xAzPBcXPr35P1TiO+4ry+FdxAxhORnin+jmpPD
         QAiq8taUHAofQgd6QoKG3tYMl2eaqKs7L21m+3huUXa8+ohVOMXhttwqZzgxWG94px
         Z0G65HHoioowPn/8xKZi4hdiJHHtX8NweY0cB3e4=
Date:   Wed, 13 Oct 2021 10:23:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        thenzl@redhat.com, sathya.prakash@broadcom.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] mpi3mr: Fix duplicate device entries when scan through
 sysfs
Message-ID: <YWaXmqGGOtJaRbOk@kroah.com>
References: <20211013081656.16494-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013081656.16494-1-sreekanth.reddy@broadcom.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 01:46:56PM +0530, Sreekanth Reddy wrote:
> When the user scans the devices through 'scan' sysfs using below
> command then the user will observe duplicate device entries
> in lsscsi command output.
> echo "- - -" > /sys/class/scsi_host/host0/scan
> 
> Fix is to set the shost's max_channel to zero.
> 
> Cc: stable@vger.kernel.org #v5.14.11+

Please tag this based on a release of Linus's, or better yet, provide a
"Fixes:" commit so that the stable people know exactly where to backport
it to.

As this is, we do not take patches only for stable kernels...

thanks,

greg k-h
