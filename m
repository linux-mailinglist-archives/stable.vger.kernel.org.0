Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DAF26DE56
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgIQOfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727666AbgIQOew (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:34:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4066321734;
        Thu, 17 Sep 2020 14:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600353233;
        bh=v8KRcrUR3WqGa0q3w6gyYsP0WrgdjJlFXQIqoQHJVd8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MCydpm2KUiH6QVWZysS7m30ZvsNj6ufxprqmnTaq3e5pLXfHKx46INfyZnfh/ElcA
         OEpRT9LQprOEmnEomp/s2W5NyVMdG74W+gpO3RwIgPPtuE0vuGxEPxICUds+hChxiC
         REHAWeWhUQNsVQgEudK5wV7t3YZAz3RlNwPNX42U=
Date:   Thu, 17 Sep 2020 16:34:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yi Zhang <yi.zhang@redhat.com>
Cc:     stable@vger.kernel.org, chaitanya.kulkarni@wdc.com,
        sagi@grimberg.me, sashal@kernel.org
Subject: Re: Please apply commit "64d452b3560b nvme-loop: set ctrl state
 connecting after init" to 5.8.9+
Message-ID: <20200917143425.GF3941575@kroah.com>
References: <16579579.1342431.1600270596173.JavaMail.zimbra@redhat.com>
 <1955465429.1342553.1600270677594.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1955465429.1342553.1600270677594.JavaMail.zimbra@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 11:37:57AM -0400, Yi Zhang wrote:
> Hi,
> 
> Please apply [1] to stable 5.8.9+, as it fixed nvme-loop connecting failure issue[2].
> 
> [1]
> 64d452b3560b nvme-loop: set ctrl state connecting after init
> 
> [2]
> https://lists.linaro.org/pipermail/linux-stable-mirror/2020-September/216482.html

So the "Fixes:" tag in the commit lies?

I would like to get an ack from the maintainers/developers on that patch
before I queue it up.

thanks,

greg k-h
