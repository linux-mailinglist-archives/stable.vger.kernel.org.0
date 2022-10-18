Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43A7602101
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 04:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJRCPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 22:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJRCPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 22:15:48 -0400
Received: from mail1.bemta31.messagelabs.com (mail1.bemta31.messagelabs.com [67.219.246.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE3B7B1DF;
        Mon, 17 Oct 2022 19:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1666059346; i=@motorola.com;
        bh=CjPAd9sMoads8OJQDo6ThPI1+ekS5X0Rv48qUuqO8bo=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=DVz0u+V63EIyOmL8gugIKGuambome2PfDOBO3jU4376sNliSIvIRlloNnGPrhANOT
         ABiMXZl4SiifAhXI+Ribk7RWF8gGH/7e0/Yp+8q7f95WsUmDCz1alaGuq7ukJ1pvhs
         EaNwey4WbF7ZKohMOv4f9Ha76KiNa9PAVNs97iJsiy4BB1QWL8DHTUl0g1x1LCEaFR
         bf3HcBazs2ZqslWO3fd6GlkzikQGChI6U8BufzdcUVWLhRm7WrruYVCyliQru/8Xba
         2sjmTZr3pm6NVHzBrjUnzrgGpZLmgG3WXY8M+R128lMghUfVI9Vv4XEotMBFjeYRSj
         Yi87YJCx1HWdQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRWlGSWpSXmKPExsWS8eKJhG4gj1+
  ywdPTHBZTGxktjrU9Ybd4cqCd0aJ32R42i+bF69ksOicuYbdY2LaExeLyrjlsFouWtTJbbGm7
  wmTx408fs8WCjY8YLVYtOMDuwOuxc9Zddo/ZHTNZPTat6mTz2D93DbvH4r7JrB79fw08tuz/z
  OjxeZNcAEcUa2ZeUn5FAmvGrwafgtVsFYvWNDA1MHaydjFycQgJTGGSeNhyhhnCWcQk8WffXc
  YuRk4OFgFVicYjb9hBbDYBNYkFr1cxg9giAhoSJzf/YAdpYBb4xixx6+lcJpCEsICXxLKWr2B
  FvALKEnvfbIFaMYtR4sDV96wQCUGJkzOfsIDYzAJaEjf+vQRq5gCypSWW/+MACXMK2Ercf76Z
  bQIj7ywkHbOQdMxC6FjAyLyK0bQ4tagstUjXUi+pKDM9oyQ3MTNHL7FKN1GvtFg3NbG4RNdQL
  7G8WC+1uFivuDI3OSdFLy+1ZBMjMFJSilj+7GC8ueyP3iFGSQ4mJVHejhm+yUJ8SfkplRmJxR
  nxRaU5qcWHGGU4OJQkePdz+CULCRalpqdWpGXmAKMWJi3BwaMkwpvDCZTmLS5IzC3OTIdInWJ
  UlBLnjeQCSgiAJDJK8+DaYIniEqOslDAvIwMDgxBPQWpRbmYJqvwrRnEORiVh3tcg43ky80rg
  pr8CWswEtDhjvxfI4pJEhJRUA1O08cylf1+aSYbVR6pdmqPXt7lsvrzARq6meyvvnhc4fU7r2
  tRsj3UMOxRYJJ7Z+LSlv2xavOSI0a35s9QOLeAXtMhyPv6t6o6CwsMWnmquA3uTkn9dinOIWs
  DsNfXed9Mlq1V3SN68+uRCinerzZr/Ofv2ikXPynEWTFrBveZ8CK/n8qoSr5p0PwnHqVudioz
  +yq7X65G35b0ZM5U/+NTcl9PzVkXF6TSEflt2RbBxdXUoo5vt/ZCJ23gPeMnmvn1nJbV3Yelz
  93d5dW+8PlRV6DAfKyu55nw9q+y3f8uCghOKJnu91glMuuj06qzQRqeTO1xWril4c+3A6wc3H
  v9YJTZ9LbevqY943wLOnVOUWIozEg21mIuKEwH8hdSFjwMAAA==
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-16.tower-706.messagelabs.com!1666059344!624135!1
X-Originating-IP: [104.232.228.24]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 12666 invoked from network); 18 Oct 2022 02:15:45 -0000
Received: from unknown (HELO va32lpfpp04.lenovo.com) (104.232.228.24)
  by server-16.tower-706.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Oct 2022 02:15:45 -0000
Received: from ilclmmrp02.lenovo.com (ilclmmrp02.mot.com [100.65.83.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp04.lenovo.com (Postfix) with ESMTPS id 4MryBm65TTzgK7f;
        Tue, 18 Oct 2022 02:15:44 +0000 (UTC)
Received: from p1g3 (unknown [10.45.7.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp02.lenovo.com (Postfix) with ESMTPSA id 4MryBm2zRxzbrlP;
        Tue, 18 Oct 2022 02:15:44 +0000 (UTC)
Date:   Mon, 17 Oct 2022 21:15:43 -0500
From:   Dan Vacura <w36195@motorola.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-usb@vger.kernel.org,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jeff Vanhoof <qjv001@motorola.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Paul Elder <paul.elder@ideasonboard.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: uvc: fix dropped frame after missed isoc
Message-ID: <Y04MT0+jKApYFfcG@p1g3>
References: <20221017205446.523796-1-w36195@motorola.com>
 <20221017205446.523796-2-w36195@motorola.com>
 <f7029f41-4f8c-9ba7-3e3b-268a743998d5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7029f41-4f8c-9ba7-3e3b-268a743998d5@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 18, 2022 at 08:50:03AM +0700, Bagas Sanjaya wrote:
> On 10/18/22 03:54, Dan Vacura wrote:
> > With the re-use of the previous completion status in 0d1c407b1a749
> > ("usb: dwc3: gadget: Return proper request status") it could be possible
> > that the next frame would also get dropped if the current frame has a
> > missed isoc error. Ensure that an interrupt is requested for the start
> > of a new frame.
> > 
> 
> Shouldn't the subject line says [PATCH v3 1/6]?

Yes. Clerical error on my side not updating this after resolving a
check-patch error... Not sure if it matters as this patch can exist on
it's own. Or if I can send this again with fixed subject line, but that
may confuse others, since there's no code difference.

> 
> -- 
> An old man doll... just what I always wanted! - Clara
> 
