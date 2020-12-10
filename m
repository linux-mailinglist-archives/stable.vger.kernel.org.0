Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03832D5AF6
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 13:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731373AbgLJMvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 07:51:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388019AbgLJMvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 07:51:35 -0500
Date:   Thu, 10 Dec 2020 13:52:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607604655;
        bh=9WaUuZgx2JHcPDHLiyyIdpZOj6ChoWve1FBbMnXLY0o=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=it2T4XEjr5nJC+dDZBOZByNtPnzIZGnSv12dkuF3JnAH/7MrW4L/mS+gsgHuZzqM7
         i9MvRg9FHDJhW7Kc3UKta693qP3b86/Voq97eEV1LCYBlAycIIne5ip5GG2WBsMwdx
         2B4BIhLrFMdTF9PQsCDv/EBb26qNcXK9U45PioVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc:     stable@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH for v4.4] mm/userfaultfd: do not access vma->vm_mm after
 calling handle_userfault()
Message-ID: <X9IZ+Y7qJw6Ld7n0@kroah.com>
References: <1606124851724@kroah.com>
 <20201123171549.20544-1-gerald.schaefer@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123171549.20544-1-gerald.schaefer@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 06:15:49PM +0100, Gerald Schaefer wrote:
> commit bfe8cc1db02ab243c62780f17fc57f65bde0afe1 upstream.

Now applied, sorry for the delay.

greg k-h
