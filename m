Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EBE33A368
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 08:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbhCNHVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 03:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234261AbhCNHVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Mar 2021 03:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFB7964EB6;
        Sun, 14 Mar 2021 07:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615706479;
        bh=xdcJ3FVVbLLdKt+WNB4RMkbOvIsy1yGixUBlVlbLEQ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LnuRk8UC2BcGAOzsV3+U171r70h17emucyC03H5UFTrptIs1qDlz6XPX4VKL/wTRP
         Fq8H6AecC2BSorsEj+eW4fvOb5u1BNvJdj3mDvngrwE5S/GKfy41mMnqLtAudZpbMt
         9/wbGcLI75Q7fp1hzbk8DjPhIKDKMJ7T5o4EIUuQ=
Date:   Sun, 14 Mar 2021 08:21:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anton Eidelman <anton@lightbitslabs.com>
Cc:     stable@vger.kernel.org, kbusch@kernel.org, sagi@grimberg.me,
        hch@lst.de
Subject: Re: nvme: ns_head vs namespace mismatch fixes
Message-ID: <YE25ac6gacMam8zh@kroah.com>
References: <20210314041320.1358030-1-anton@lightbitslabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210314041320.1358030-1-anton@lightbitslabs.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 13, 2021 at 08:13:18PM -0800, Anton Eidelman wrote:
> *This message is sent in confidence for the addressee 
> only.  It
> may contain legally privileged information. The contents are not 
> to be
> disclosed to anyone other than the addressee. Unauthorized recipients 
> are
> requested to preserve this confidentiality, advise the sender 
> immediately of
> any error in transmission and delete the email from their 
> systems.*
> 

email deleted
