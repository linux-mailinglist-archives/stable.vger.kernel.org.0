Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A47F4EF554
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350967AbiDAPNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350581AbiDAPAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 11:00:12 -0400
Received: from mail1.bemta33.messagelabs.com (mail1.bemta33.messagelabs.com [67.219.247.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F359185444;
        Fri,  1 Apr 2022 07:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1648824482; i=@motorola.com;
        bh=WROaxWWWhA/Ka6VGT9NzyKO1Nh1SHOr11ZyLRrXkfR8=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=YT9MHsIuTMP2sKtPAnUbU0aitOxqst3UA6DNHLU8FJfIZhJs2z5MLzgJ36d//TE0D
         Dy9bSmjDl8rJQzHru+mHwo/wtYC6H+jpOW05rfNoS9FtUx6I9VBQujTMrKWykQ6D0N
         UaiZKF9Omck/NXOkcKnss+ieA6tdETflC9/37mtxr/881LKMNdpb+66GjZBQnCkRD7
         b5OAniYpPD0ev5qRTg/Bzq5S41jlf8wtF+/9OzhH2L2oUGjOAZVe3qkBqtaVflDO4E
         0tjqPvHJpHo5gVJAqFwbGDI712b2GHLfeBmJUqvByMIbAgxz4nZmZ5snLvaIc7/I1h
         KCz6tnMYj/hPg==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRWlGSWpSXmKPExsWS8eKJqO5CAfc
  kgwm7dS2OtT1ht5izOdriyYF2RovmxevZLDonLmG3WNi2hMXi8q45bBaLlrUyWzycfZXR4u2d
  6SwWCzY+YnTg9pjdMZPVY/MKLY9NqzrZPPbPXcPusbhvMqvH501yHoe2v2ELYI9izcxLyq9IY
  M248+w1U8F01orOT/+ZGhins3QxcnEICUxnknh4o4sZwlnEJLFrx1Egh5ODRUBF4s7MnywgNp
  uAmsSC16vA4iICxhL9Z2exg9jMAk+ZJCbO4gOxhQWCJNq6/4LFeQWUJZ58W8YIYgsJhEv8XbC
  cFSIuKHFy5hMWiF4tiRv/XjJ1MXIA2dISy/9xgIQ5BTQl2hdvY5nAyDsLSccsJB2zEDoWMDKv
  YrROKspMzyjJTczM0TU0MNA1NDTRNTfUNTI00kus0k3UKy3WTU0sLtEFcsuL9VKLi/WKK3OTc
  1L08lJLNjECoyKlyP3KDsb7K3/qHWKU5GBSEuW9vMEtSYgvKT+lMiOxOCO+qDQntfgQowwHh5
  IELx+fe5KQYFFqempFWmYOMEJh0hIcPEoivIasQGne4oLE3OLMdIjUKUZFKXHeIyB9AiCJjNI
  8uDZYUrjEKCslzMvIwMAgxFOQWpSbWYIq/4pRnINRSZh3Ez/QFJ7MvBK46a+AFjMBLda/4Qqy
  uCQRISXVwORdufPntCVVDsll+msvc+y9vsjfK4PbbNZirX3zFCsbJxjkGiilrNDWq2334HJ2m
  2CatKWG5dX9i3UNqQwOOVGPeL01X7sc7fS2Kjgc4nb7/KK1EzTn2zRbr7z6I3C+6SMla9WtlR
  YvbnoYvZDXSlx+pum74VqtTf338s6GGwQz3n42L8+M+c90/d7oNNFTWzbO2WbYz/BP68/T0B+
  /X3S+O3xG4/qDSy2eAcVXtvmo3nl9pi972yU5P+uUE8mPs/bnhNa+MggS0pv39MbaRMXbK6Vu
  V3XpP+D89tyZnyHuynT5gy4u8c4sgfYyZb1Klvdvn3hoJJ/QmrG85SN7Sk74ufXi9gc4mi9yV
  nwOV2Ipzkg01GIuKk4EALAcgk2FAwAA
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-8.tower-715.messagelabs.com!1648824481!21610!1
X-Originating-IP: [104.232.228.21]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.85.5; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 20062 invoked from network); 1 Apr 2022 14:48:01 -0000
Received: from unknown (HELO va32lpfpp01.lenovo.com) (104.232.228.21)
  by server-8.tower-715.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 1 Apr 2022 14:48:01 -0000
Received: from va32lmmrp01.lenovo.com (va32lmmrp01.mot.com [10.62.177.113])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp01.lenovo.com (Postfix) with ESMTPS id 4KVNM52X3GzgNVf;
        Fri,  1 Apr 2022 14:48:01 +0000 (UTC)
Received: from p1g3 (unknown [10.45.5.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by va32lmmrp01.lenovo.com (Postfix) with ESMTPSA id 4KVNM46W96zf6f8;
        Fri,  1 Apr 2022 14:48:00 +0000 (UTC)
Date:   Fri, 1 Apr 2022 09:47:54 -0500
From:   Dan Vacura <w36195@motorola.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Carlos Bilbao <bilbao@vt.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: uvc: allow changing interface name via
 configfs
Message-ID: <YkcQmrm30D7cNPDo@p1g3>
References: <20220331211155.412906-1-w36195@motorola.com>
 <YkaZcSsadjHp1yJZ@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkaZcSsadjHp1yJZ@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 01, 2022 at 08:19:29AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Mar 31, 2022 at 04:11:50PM -0500, Dan Vacura wrote:
> > Add a configfs entry, "function_name", to change the iInterface field
> > for VideoControl. This name is used on host devices for user selection,
> > useful when multiple cameras are present. The default will remain "UVC
> > Camera".
> > 
> > Cc: <stable@vger.kernel.org> # 5.10+
> 
> Why is adding a new feature a stable kernel issue?
> 
> confused,
> 
> greg k-h

The intention is to get this change integrated into the Android GKI 5.10
and 5.15 release lines.

Sorry for the confusion or if I misunderstood the process,

Dan

