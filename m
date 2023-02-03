Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43DCD689710
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjBCKiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbjBCKif (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:38:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E23A2D7C;
        Fri,  3 Feb 2023 02:38:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1813561E92;
        Fri,  3 Feb 2023 10:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C898DC433EF;
        Fri,  3 Feb 2023 10:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420710;
        bh=vQS7C9kztdfXOeeXrW+VPQxT7S8tVcrsOlD1rJ+FntI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hv+WqU+w8pCyGraIqN/K5t2HEqjp+Z7cP7b35VL9BbikrV8LOqTlgSbaaDcDkEBoa
         kkh4IakS5iNLzJiNRoP21qeoz0Gj6MSalQ/4uJ8Ed86jdPHu22HEo2OudVKbTqZhvT
         SAjamje2Z1lkkljI+sfU/KgxkqRTC7D/2vEVhyy4=
Date:   Fri, 3 Feb 2023 11:18:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linyu Yuan <quic_linyyuan@quicinc.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Jack Pham <quic_jackp@quicinc.com>,
        Wesley Cheng <quic_wcheng@quicinc.com>,
        Pratham Pratap <quic_ppratap@quicinc.com>
Subject: Re: [PATCH] usb: roles: disable pm for role switch device
Message-ID: <Y9zfg6+Fgs5Tck49@kroah.com>
References: <1675419059-30078-1-git-send-email-quic_linyyuan@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675419059-30078-1-git-send-email-quic_linyyuan@quicinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 06:10:59PM +0800, Linyu Yuan wrote:
> there is no PM operation for a role switch device,
> call device_set_pm_not_required() in usb_role_switch_register() to disable.
> 
> Cc: stable@vger.kernel.org # 5.4+
> Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>

What commit id does this fix?

thanks,

greg k-h
