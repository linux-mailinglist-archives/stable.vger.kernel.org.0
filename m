Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C78603052
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 17:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiJRP40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 11:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiJRP4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 11:56:19 -0400
Received: from mail1.bemta31.messagelabs.com (mail1.bemta31.messagelabs.com [67.219.246.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78206BECC6
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 08:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1666108570; i=@motorola.com;
        bh=c1XQZ8xVGZiucAD/nqtpnHU9sPJttghPjk1kwBfPNMg=;
        h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type;
        b=XWuz5Qylse4frUdddOVCV01HDXaWSC2V7/udQK1BrexTgyLKAxJrgjls216x8FkLJ
         ghTtz92pyXJOumySpEx+UHniqKzzmIMUFjP7Jlsd8ULyeG0cw8tCQmMBOMp688U5NW
         J9M15VvlygImi2f49ntM0mMl+U4KNc2WUcGWdRWGxrXybfdAdzOsOkGHmuQu1W5LTi
         Bri5J709JBN8hcNrvIZiOXzw8NfJdtEs9TTgPFmx+PiVthZzr42ouMLD2d6KC4Zohl
         DYZW6gEQkBSbkMRjINqZQbM7sPOZolesb/yVLGa+PVClzCcF5H14bY0qwPc0OlIYQe
         2l8bAeNhHmQ5Q==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRWlGSWpSXmKPExsWS8eKJqO7MM37
  JBrs+61g0L17PZrFg4yNGByaP/XPXsHt83iQXwBTFmpmXlF+RwJpx5XoTa8F91ooL33ayNzC+
  Zeli5OIQEpjKJNF58xoThLOUSWLu/RbmLkZODhYBVYlzB26C2WwCahILXq8Cs0UEjCX6z85iB
  7GZBaQk1n06xAZiCws4SHyc+4QVxOYVUJbo+vuCCcIWlDg58wkLRL2WxI1/L4HiHEC2tMTyfx
  wTGLlnIamahaRqFkLVAkbmVYymxalFZalFuuZ6SUWZ6RkluYmZOXqJVbqJeqXFuqmJxSW6hnq
  J5cV6qcXFesWVuck5KXp5qSWbGIEBlVLEdHUH49Zlf/QOMUpyMCmJ8j465JcsxJeUn1KZkVic
  EV9UmpNafIhRhoNDSYJ3zSmgnGBRanpqRVpmDjC4YdISHDxKIrwZx4HSvMUFibnFmekQqVOMi
  lLivM4gfQIgiYzSPLg2WERdYpSVEuZlZGBgEOIpSC3KzSxBlX/FKM7BqCTMmwMyniczrwRu+i
  ugxUxAi023gC0uSURISTUw6fmu5Urzkz7lt6wz/9IO/q/LLeKyD89UMjihLHu/M8Q2Olf0sP8
  zHkkelzfJi77O0Xlvu5jp2cJbvS7v+O5fnPKkpy72/OM5s7wuXuQ7lrrKYbZKg0DgHI+JjmUh
  PEe3ZjO/tGwK+c54rmG2lByH9aHzy84dkZz0tTK6hZPhzb2fIcYzHrjmBlqwHL/+yUtHMPiNh
  a9Qv3k3q8yj7x7Rl7/aeedKbXM4vEz24+ljVx8HGtTMS+Mwm8Lk0d/dffiizdEVm5icktv6Kz
  9fv/tU6Va2ipLHn7kKhwTT0marM8+LdX60zmL+i/XXNs5M93mVmyUj5L+cY6+V8rS4AKb+4sU
  WFT1xvw4oHVrAV/5UiaU4I9FQi7moOBEAtV4jkiMDAAA=
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-3.tower-706.messagelabs.com!1666108569!99760!1
X-Originating-IP: [104.232.228.21]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 2928 invoked from network); 18 Oct 2022 15:56:09 -0000
Received: from unknown (HELO va32lpfpp01.lenovo.com) (104.232.228.21)
  by server-3.tower-706.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Oct 2022 15:56:09 -0000
Received: from ilclmmrp01.lenovo.com (ilclmmrp01.mot.com [100.65.83.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp01.lenovo.com (Postfix) with ESMTPS id 4MsJPP3rVxzf6mc;
        Tue, 18 Oct 2022 15:56:09 +0000 (UTC)
Received: from p1g3 (unknown [100.64.172.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp01.lenovo.com (Postfix) with ESMTPSA id 4MsJPP2jWnzbvDd;
        Tue, 18 Oct 2022 15:56:09 +0000 (UTC)
Date:   Tue, 18 Oct 2022 10:55:49 -0500
From:   Dan Vacura <w36195@motorola.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: usb: gadget: uvc: scatter gather support fixes to 5.15+
Message-ID: <Y07MhTJpuqr9xA3E@p1g3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Requesting for the following patches to be picked to stable 5.15+ where
the following change was integrated: e81e7f9a0eb9 ("usb: gadget: uvc:
add scatter gather support")

Without these fixes data corruption and smmu panics will occur in the
uvc gadget driver.

The fixes to be integrated are:

 859c675d84d4 ("usb: gadget: uvc: consistently use define for headerlen")
 f262ce66d40c  ("usb: gadget: uvc: use on returned header len in video_encode_isoc_sg")
 61aa709ca58a ("usb: gadget: uvc: rework uvcg_queue_next_buffer to uvcg_complete_buffer")
 9b969f93bcef ("usb: gadget: uvc: giveback vb2 buffer on req complete")
 aef11279888c ("usb: gadget: uvc: improve sg exit condition")

They apply cleanly on 5.15.y

Thanks,

Dan
