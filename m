Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0506976A7
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 07:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBOGwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 01:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbjBOGwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 01:52:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0322A869E
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 22:52:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88C3161A34
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 06:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D8BC433D2;
        Wed, 15 Feb 2023 06:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676443971;
        bh=R7/L2GLaIGFwL4GsfolgcEskuOulMiPccjns1j+WJ9Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZViLIJB3yx9h/pv9WQUGX0WuLyomgMrGZ1dU5Cp2CYUHN74dBP1JDFja2z1Ybsmt8
         qmdZPdGpmDNzaS6fiWuwzKJ+FcrBBznQKi/f+MPioipTTkmPuwK0krHDBkK0dy3Cf+
         pFe1dupFvCfFUK/V181Ome469T8qEoSKJwCKRUU8=
Date:   Wed, 15 Feb 2023 07:52:48 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Xu Yang <xu.yang_2@nxp.com>
Cc:     "heikki.krogerus@linux.intel.com" <heikki.krogerus@linux.intel.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [EXT] patch "usb: typec: tcpm: fix create duplicate
 source/sink-capabilities file" added to usb-testing
Message-ID: <Y+yBQByQcvIRqvWw@kroah.com>
References: <167638223881128@kroah.com>
 <DB7PR04MB4505FB65BB4277C9D3182B598CA39@DB7PR04MB4505.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB7PR04MB4505FB65BB4277C9D3182B598CA39@DB7PR04MB4505.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 15, 2023 at 05:45:25AM +0000, Xu Yang wrote:
> Just noticed that port->partner_source_caps should also be reset to NULL.
> 
> I'll send a V4 for this soon.

Ick, let me go revert this then :(


