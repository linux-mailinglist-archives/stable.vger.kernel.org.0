Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96866661EBD
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 07:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbjAIGie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 01:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbjAIGid (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 01:38:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570DB11A1E;
        Sun,  8 Jan 2023 22:38:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCD1EB80C6D;
        Mon,  9 Jan 2023 06:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F75C433D2;
        Mon,  9 Jan 2023 06:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673246309;
        bh=ukfbSqJW0Cm2XtvJ49T4sD/afoBZVz0kpsHg//QmYJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lYANWEn1/25u5rxtA9K7ypYuZLqX8hqXoZvE9XUyxGgGE8i5zQ2Mn7jnH/igwGQb2
         3U8q7NjUatgPYOlx0ZnSf3JYmxWap8BMvkmAmOw0Y7c8oA7Vqpgfyb/qPFr75iKbX3
         M3n/qge7ELglOR7PAqMkP+f2wifnUZeJ0UY8bN9k=
Date:   Mon, 9 Jan 2023 07:38:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     ChiYuan Huang <cy_huang@richtek.com>
Cc:     ChiYuan Huang <u0084500@gmail.com>, linux@roeck-us.net,
        heikki.krogerus@linux.intel.com, matthias.bgg@gmail.com,
        tommyyl.chen@mediatek.com, macpaul.lin@mediatek.com,
        gene_chen@richtek.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: typec: tcpm: Fix altmode re-registration causes
 sysfs create fail
Message-ID: <Y7u2Yi+UeqMcVhad@kroah.com>
References: <1671096096-20307-1-git-send-email-u0084500@gmail.com>
 <Y5rsdo/SGHJM4UKG@kroah.com>
 <CADiBU3-iVLQf6Q5SzOB_pMCs2PGcFuWryjpDn5Qvz41WQ6C2RA@mail.gmail.com>
 <Y5sIZ3zC6o4ARDEn@kroah.com>
 <20230109014123.GA27423@linuxcarl2.richtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109014123.GA27423@linuxcarl2.richtek.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 09, 2023 at 09:41:23AM +0800, ChiYuan Huang wrote:
> ************* Email Confidentiality Notice ********************
> 
> The information contained in this e-mail message (including any attachments) may be confidential, proprietary, privileged, or otherwise exempt from disclosure under applicable laws. It is intended to be conveyed only to the designated recipient(s). Any use, dissemination, distribution, printing, retaining or copying of this e-mail (including its attachments) by unintended recipient(s) is strictly prohibited and may be unlawful. If you are not an intended recipient of this e-mail, or believe that you have received this e-mail in error, please notify the sender immediately (by replying to this e-mail), delete any and all copies of this e-mail (including any attachments) from your system, and do not disclose the content of this e-mail to any other person. Thank you!

Now deleted.

For obvious reasons, this wording is not compatible with kernel
development :(
