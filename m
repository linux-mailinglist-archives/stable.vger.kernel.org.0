Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139864E5F0F
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 08:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238805AbiCXHCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 03:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348399AbiCXHCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 03:02:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C5D554A1
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 00:01:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 096D1B82256
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 07:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536F8C340EC;
        Thu, 24 Mar 2022 07:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648105269;
        bh=mffiJXr/QoFbBqJyXC43LrgFO77Ap5Y4Z3PmK7AcEMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rzpjDlQwVX/rSSpD4C7nOB6rGpIPriVK74KRYp7mhpe+pWS3vL3I4AvuprgkeS8vh
         exhUcgM1GPzI3PXRtbxoQxoMPs+aqqOC95XDO2BbyG3ZckFvjTlb5Ih3dBYhf0hYgc
         lgVnm1MQToHMH6hYZTD77fcj98aGlDK/+K7clMO0=
Date:   Thu, 24 Mar 2022 08:01:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Cc:     stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] Bluetooth: btusb: Add another Realtek 8761BU (6dfbe29f)
Message-ID: <YjwXMycnSIgHBxIZ@kroah.com>
References: <6b9b8cf4-d343-0cca-5908-d990758283b8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b9b8cf4-d343-0cca-5908-d990758283b8@gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 23, 2022 at 09:16:42PM +0100, Ismael Ferreras Morezuelas wrote:
> While this (6dfbe29f) patch is still in bluetooth-next, I think once it's merged it
> should go into the stable tree. Keep in mind that I'm not the author.

Please let us know when it lands in Linus's tree, we can't do anything
for a stable release until that happens.

thanks,

greg k-h
