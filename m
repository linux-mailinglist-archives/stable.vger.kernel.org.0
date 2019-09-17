Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACED2B54EA
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 20:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfIQSKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 14:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbfIQSKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Sep 2019 14:10:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84A6B21670;
        Tue, 17 Sep 2019 18:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568743821;
        bh=rSJwj07pvZ3EVYLZRzfUdwVEHgaLbLQKvUUQHP2GWEc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f2Fe3Jo9Wi/k4Cifc/Q4c6QJhJRc+lNRKdB7lCOCaggiYxGWHOsaj/LCE9X96abvW
         /HRidO/zLNpeJ0Xw3UAY8ZA2p8BS5JhTz0HO2mZgzmMnPOaH2pDXZ12oF3SOxE3rL8
         MIXX50l/7VG3oDQ/u0q0g6blHHbJMOxDZNEHfiNE=
Date:   Tue, 17 Sep 2019 20:10:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jean Delvare <jdelvare@suse.de>
Cc:     stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [BACKPORT] nvmem: Use the same permissions for eeprom as for
 nvmem
Message-ID: <20190917181018.GC1570310@kroah.com>
References: <20190917163001.5c775b61@endymion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917163001.5c775b61@endymion>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 17, 2019 at 04:30:01PM +0200, Jean Delvare wrote:
> [ Upstream commit e70d8b287301eb6d7c7761c6171c56af62110ea3 ]
> 
> The compatibility "eeprom" attribute is currently root-only no
> matter what the configuration says. The "nvmem" attribute does
> respect the setting of the root_only configuration bit, so do the
> same for "eeprom".
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Fixes: b6c217ab9be6 ("nvmem: Add backwards compatibility support for older EEPROM drivers.")
> Reviewed-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Link: https://lore.kernel.org/r/20190728184255.563332e6@endymion
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> This is the backport of commit e70d8b287301 "nvmem: Use the same
> permissions for eeprom as for nvmem" for stable kernel branches 4.19,
> 4.14 and 4.9. Thanks.

Now queued up, thanks.

greg k-h
