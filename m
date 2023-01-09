Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F83A661EB7
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 07:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbjAIGhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 01:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjAIGhm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 01:37:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4B8FAC8;
        Sun,  8 Jan 2023 22:37:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B61260EF9;
        Mon,  9 Jan 2023 06:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C11C433EF;
        Mon,  9 Jan 2023 06:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673246260;
        bh=bVLTMxPnUysXSdp+BMthEAJ/MbC4ZegjDQ4Z+dd2TJE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eNgCVLHrJhMKwApUN0XPi8zRLLKGwOrG9MIFlETRZLjAEC2zIQCPSg2epNZU9DYTL
         BvsCofc1B42wNwPNsrsVKY2BfXq5pF/VRHzKllBra2iJoeXssmJIBUvWaSucE44MOk
         2EkmnXWPjadGIl8DaOzH3Ga4pEEbIWOM17CqJzE4=
Date:   Mon, 9 Jan 2023 07:37:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     cy_huang@richtek.com
Cc:     linux@roeck-us.net, heikki.krogerus@linux.intel.com,
        matthias.bgg@gmail.com, gene_chen@richtek.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: typec: tcpm: Fix altmode re-registration causes
 sysfs create fail
Message-ID: <Y7u2MSCNyeNxwei5@kroah.com>
References: <1673228092-27281-1-git-send-email-cy_huang@richtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1673228092-27281-1-git-send-email-cy_huang@richtek.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 09, 2023 at 09:34:52AM +0800, cy_huang@richtek.com wrote:
> ************* Email Confidentiality Notice ********************
> 
> The information contained in this e-mail message (including any attachments) may be confidential, proprietary, privileged, or otherwise exempt from disclosure under applicable laws. It is intended to be conveyed only to the designated recipient(s). Any use, dissemination, distribution, printing, retaining or copying of this e-mail (including its attachments) by unintended recipient(s) is strictly prohibited and may be unlawful. If you are not an intended recipient of this e-mail, or believe that you have received this e-mail in error, please notify the sender immediately (by replying to this e-mail), delete any and all copies of this e-mail (including any attachments) from your system, and do not disclose the content of this e-mail to any other person. Thank you!

Now deleted.
