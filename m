Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC685F79C9
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 16:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiJGOjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 10:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiJGOjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 10:39:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F58CFC1C1;
        Fri,  7 Oct 2022 07:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0980B8238D;
        Fri,  7 Oct 2022 14:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB26CC433C1;
        Fri,  7 Oct 2022 14:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665153556;
        bh=tPYxV/+NjjL2mh3c9K1/ql/E+E6pp8f4FBqUgV/Ws1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rJBQMQb4OScJVRhyz9oCuOH5/0dlwDAjV1Fk5v0thLKdHAkJMTcXipwX2k3mYpYqz
         SWzP5nIo+TGga8TIKI9dTy00M+4ea32TLWRlxaG/dwpe3WdXiQJH9rAKNMN1nG/Mjj
         8Q5KXGb6+LMajAJ+KQe0UitTnXM8H/AtbYP96M18=
Date:   Fri, 7 Oct 2022 16:39:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Bastian Rieck <bastian@rieck.me>, grzegorz.alibozek@gmail.com,
        andrew.co@free.fr, meven29@gmail.com, pchernik@gmail.com,
        jorge.cep.mart@gmail.com, danielmorgan@disroot.org,
        bernie@codewiz.org, saipavanchitta1998@gmail.com,
        rubin@starset.net, maniette@gmail.com, nate@kde.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1 0/2] usb: typec: UCSI resume fix
Message-ID: <Y0A6Pb5owOWVVQET@kroah.com>
References: <20221007100951.43798-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007100951.43798-1-heikki.krogerus@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 07, 2022 at 01:09:49PM +0300, Heikki Krogerus wrote:
> Hi Greg,
> 
> These two patches fix an issue where the ucsi drivers fail to detect
> changes on the connection status (connections/disconnections) that
> happen while the system is suspended.
> 
> 
> Heikki Krogerus (2):
>   usb: typec: ucsi: Check the connection on resume
>   usb: typec: ucsi: acpi: Implement resume callback
> 
>  drivers/usb/typec/ucsi/ucsi.c      | 42 +++++++++++++++++++++---------
>  drivers/usb/typec/ucsi/ucsi_acpi.c | 10 +++++++
>  2 files changed, 39 insertions(+), 13 deletions(-)

These are ok to go in after -rc1, right?

thanks,

greg k-h
