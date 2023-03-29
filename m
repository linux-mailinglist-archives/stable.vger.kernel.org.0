Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366DA6CD4D2
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 10:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjC2IiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 04:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjC2IiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 04:38:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1D71FE7;
        Wed, 29 Mar 2023 01:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14CDB61B84;
        Wed, 29 Mar 2023 08:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9465C433D2;
        Wed, 29 Mar 2023 08:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680079074;
        bh=9ifbxrOQWPIeIXQUfOAAtE87FHbtT0f+fZkTonCJ/Us=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xxft1PeaaYNLisckSI8Z/hoioHg82A5kC7yJu2lWb4T9zohW1rdetadLv5/uVFXyn
         pqwA8YnR5QTfQHI+C67SG25cxxS9fFovQ4g/CEVRTgUTJfvQUeiMRHKJ0QIcfAoAw0
         3riuWImoqblZDWEA0wo8uKQoavlyRxAbAvFJSuqE=
Date:   Wed, 29 Mar 2023 10:37:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     peter.chen@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: cdnsp: Fixes issue with redundant Status Stage
Message-ID: <ZCP435eCZhIIxesr@kroah.com>
References: <20230321124053.200483-1-pawell@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321124053.200483-1-pawell@cadence.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 08:40:53AM -0400, Pawel Laszczak wrote:
> In some cases, driver trees to send Status Stage twice.
> The first one from upper layer of gadget usb subsystem and
> second time from controller driver.
> This patch fixes this issue and remove tricky handling of
> SET_INTERFACE from controller driver which is no longer
> needed.
> 
> cc: <stable@vger.kernel.org>
> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> 
> ---
> Changelog:
> v2:
> - removed Smatch static checker warning

This is already in 6.3-rc4, right?

thanks,

greg k-h
