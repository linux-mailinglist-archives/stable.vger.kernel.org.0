Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B18B5DD30F
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 20:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiIUSND convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 21 Sep 2022 14:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiIUSNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 14:13:01 -0400
X-Greylist: delayed 542 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 21 Sep 2022 11:13:01 PDT
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0511E9E6AE
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 11:13:00 -0700 (PDT)
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C93F12121F;
        Wed, 21 Sep 2022 18:03:57 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf03.hostedemail.com (Postfix) with ESMTPA id E42056000B;
        Wed, 21 Sep 2022 18:03:53 +0000 (UTC)
Message-ID: <e9863ed5576cb93a6fd9b59cd19be9b71fda597d.camel@perches.com>
Subject: Re: Linux 4.14.294
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
Date:   Wed, 21 Sep 2022 11:03:52 -0700
In-Reply-To: <1663669061138255@kroah.com>
References: <1663669061118192@kroah.com> <1663669061138255@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: E42056000B
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Stat-Signature: gtgf7mb4b6jzm31dhmnjs1dzhidhpxh6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+f2m+3yU1RbH2gvZ9sp4GWdKfG7M0p4WE=
X-HE-Tag: 1663783433-908221
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-09-20 at 12:17 +0200, Greg Kroah-Hartman wrote:
[]
> diff --git a/drivers/hid/intel-ish-hid/ishtp-hid.h b/drivers/hid/intel-ish-hid/ishtp-hid.h
[]
> @@ -118,7 +118,7 @@ struct report_list {
>   * @multi_packet_cnt:	Count of fragmented packet count
>   *
>   * This structure is used to store completion flags and per client data like
> - * like report description, number of HID devices etc.
> + * report description, number of HID devices etc.
>   */
>  struct ishtp_cl_data {
>  	/* completion flags */

Needless backporting of typo fixes reduces confidence in the
backport process.

