Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FA52DBE9
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 13:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfE2LdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 07:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbfE2LdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 07:33:01 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CD2E20B1F;
        Wed, 29 May 2019 11:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559129580;
        bh=XkECWABlEvEhM9Y67L5uvCc5xATiVogORIyBygButWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yjQe8+S1hoSdJ6d1ikUEEbwe9ChQJsHAv4QCUf3ydbvihOkqyuY/EA617UqfsUL/y
         oIVpS0Yv8bNmD/ofhX3ATTzRGqecTBEdAY5pn1x7u9lj4ufwvp5djwwBfBpjJlfrzU
         2NAHKgAUpGk5+76zcZfDjbHB878ZX4J5UR3QkZ00=
Date:   Wed, 29 May 2019 04:33:00 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: Please revert "btrfs: Honour FITRIM range constraints during
 free space trim" from all stable trees
Message-ID: <20190529113300.GB11952@kroah.com>
References: <20190529112314.GY15290@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529112314.GY15290@suse.cz>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 01:23:14PM +0200, David Sterba wrote:
> Hi,
> 
> upon closer inspection we found a problem with the patch
> 
> "btrfs: Honour FITRIM range constraints during free space trim"
> 
> that has been merged to 5.1.4. This could happen with ranged FITRIM
> where the range is not 'honoured' as it was supposed to.
> 
> Please revert it and push in the next stable release so the buggy
> version is not in the wild for too long.
> 
> Affected trees:
> 
> 5.0.18
> 5.1.4
> 4.9.179
> 4.19.45
> 4.14.122
> 
> Master branch will have the revert too. Thanks.

What is the git commit id of the revert in Linus's tree?

thanks,

greg k-h
