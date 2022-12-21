Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2BF653539
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 18:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbiLURbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 12:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbiLURaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 12:30:39 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9981869B;
        Wed, 21 Dec 2022 09:30:37 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id v70so13917595oie.3;
        Wed, 21 Dec 2022 09:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XTMksh38QZWdhc3MFQPyARLjgNFZKN0aQkfKJxelMW0=;
        b=D+qWobDOn0kr4BfOI4OKTK/SPTZLdJj/OflLrRu/C2XG/Lj4hLchfsEfAGBiprX6lu
         kKzbOA69PSnUeClQ/Vcg5tbiKkBdHDuiDjyWfxMQX6V2S4zOd7PlKyntiZ2IACK6s6B0
         0XEcmKUJ4fAScFJSJzgfADP9uRJGzFlJQwqS3NgXKpeEUq/lMYZWBRBDWLAFPOr9M1G6
         +O8CI3sOAnINY04bw1UWvtEigLTJTmQGhx9p60dpBFST8VlGhFpi6tMC+L4VSMWPQOoS
         DUbrAlCUJtY8sxFc0vkFrHVniey1SMSgQM1J5UK+WlRWD7NiuzFrvtATypJJVDpSDqIw
         svvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XTMksh38QZWdhc3MFQPyARLjgNFZKN0aQkfKJxelMW0=;
        b=p+cl87uRhdpabXJ5EhGJXXGOFv1hNFDOZpcoDKNQdeIQQ0u/Hmciz2GYA05S1psADL
         q6qmChD3ci2kY4Fb0vYfN0Laof3Ckzj7l5zaDt7kJ6iTl5srRE91EqlDY/pJ5fLcJ9TO
         cvvAB/hfxw/44Oz4iYdIWTUOKCBYtmamIT6FWCN4L5g8Xsh6LY9ZoUZgyq0n4n2VZ2iv
         hWgblxx/aT8iDfbEAtAQY9ydBKR7kD4qyosX/BBdYds7R/iD2wSxqWgKF3JhV2EpqcYT
         dmq56xczi8aQeKHCi/Yn5NWjLHzeFRCE8oXPwAitt+v1lC/xDnXRSTuLaM+ju8Yhw8cl
         idbA==
X-Gm-Message-State: AFqh2krH5/wluMjw+gaPLbwjgCNGyIBFQA3iBjMrh4JVYO4FJG61pkj4
        8RQViwSqJ9KhJKrFkm1yUMU=
X-Google-Smtp-Source: AMrXdXtL6geDc+mAb9bOZeZ1CRWC26stEF4v5U0j/B8WYZw5mD1qG6gnezeOzAWHLWluS6UaFXnRNA==
X-Received: by 2002:a05:6808:1995:b0:35c:41bb:f8d1 with SMTP id bj21-20020a056808199500b0035c41bbf8d1mr8936565oib.45.1671643837101;
        Wed, 21 Dec 2022 09:30:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a19-20020a05680804d300b0035ba52d0efasm4994655oie.52.2022.12.21.09.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 09:30:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 21 Dec 2022 09:30:35 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ferry Toth <fntoth@gmail.com>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 1/2] usb: ulpi: defer ulpi_register on ulpi_read_id
 timeout
Message-ID: <20221221173035.GB2470607@roeck-us.net>
References: <20221205201527.13525-1-ftoth@exalondelft.nl>
 <20221205201527.13525-2-ftoth@exalondelft.nl>
 <20221220194334.GA942039@roeck-us.net>
 <4d6f0bdb-500b-7ae5-ef10-a844a7abbf23@gmail.com>
 <20221221124104.GB1353152@roeck-us.net>
 <b6692501-5c6e-945a-9a54-986ae8dd1687@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6692501-5c6e-945a-9a54-986ae8dd1687@gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 03:29:09PM +0100, Ferry Toth wrote:
> Hi
> 
> On 21-12-2022 13:41, Guenter Roeck wrote:
> > On Wed, Dec 21, 2022 at 11:07:50AM +0100, Ferry Toth wrote:
> > > Hi,
> > > 
> > > On 20-12-2022 20:43, Guenter Roeck wrote:
> > > > On Mon, Dec 05, 2022 at 09:15:26PM +0100, Ferry Toth wrote:
> > > > > Since commit 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral
> > > > > if extcon is present") Dual Role support on Intel Merrifield platform
> > > > > broke due to rearranging the call to dwc3_get_extcon().
> > > > > 
> > > > > It appears to be caused by ulpi_read_id() on the first test write failing
> > > > > with -ETIMEDOUT. Currently ulpi_read_id() expects to discover the phy via
> > > > > DT when the test write fails and returns 0 in that case, even if DT does not
> > > > > provide the phy. As a result usb probe completes without phy.
> > > > > 
> > > > > Make ulpi_read_id() return -ETIMEDOUT to its user if the first test write
> > > > > fails. The user should then handle it appropriately. A follow up patch
> > > > > will make dwc3_core_init() set -EPROBE_DEFER in this case and bail out.
> > > > > 
> > > > > Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
> > > > Hi,
> > > > 
> > > > this patch results in some qemu test failures, specifically xilinx-zynq-a9
> > > > machine and zynq-zc702 as well as zynq-zed devicetree files, when trying
> > > > to boot from USB drive. The log shows
> > > I'm not familiar with that platform. Does it use dt to discover the ulpi
> > > device?
> > > 
> > The dt usb description includes
> > 
> > 	usb_phy0: phy0 {
> >                  compatible = "usb-nop-xceiv";
> >                  #phy-cells = <0>;
> >          };
> > 
> > ...
> > 
> > &usb0 {
> >          status = "okay";
> >          dr_mode = "host";
> >          usb-phy = <&usb_phy0>;
> > };
> > 
> > ...
> > 
> >                  usb0: usb@e0002000 {
> >                          compatible = "xlnx,zynq-usb-2.20a", "chipidea,usb2";
> >                          status = "disabled";
> >                          clocks = <&clkc 28>;
> >                          interrupt-parent = <&intc>;
> >                          interrupts = <0 21 4>;
> >                          reg = <0xe0002000 0x1000>;
> >                          phy_type = "ulpi";
> >                  };
> > 
> > The chipidea core initialization code includes
> > 
> >          if (!platdata->phy_mode)
> >                  platdata->phy_mode = of_usb_get_phy_mode(dev->of_node);
> > 
> > Does that mean that every chipidea based usb implementation specifying
> > 	phy_type = "ulpi";
> > in their devicetree description will now fail, plus maybe others
> > who determine the phy mode from devicetree ?
> I don't think so.
> > > I'm guessing that the problem is actually caused by "usb: ulpi: defer
> > > ulpi_register on ulpi_read_id timeout".
> > > 
> > Confused. Isn't that this patch ?
> Ehem. Yes.
> > > ulpi_read_id() now returns ETIMEDOUT due to the test write ulpi_write(ulpi,
> > > ULPI_SCRATCH, 0xaa) failing.
> > > 
> > > Maybe  we can create a fix by skipping the test write in case dt discovery
> > > is available and calling of_device_request_module() directly, instead of
> > > masking the timed out test write as it was before?
> > > 
> > I have no idea. All I can see is that it appears that there was a reason
> > for not returning an error if that test write failed.
> 
> It seems to have been a quick patch to solve a power sequencing issue:
> 
> "The ULPI bus code supports native enumeration by reading the
> vendor ID and product ID registers at device creation time, but
> we can't be certain that those register reads will succeed if the
> phy is not powered up. To avoid any problems with reading the ID
> registers before the phy is powered we fallback to DT matching
> when the ID reads fail.
> 
> If the ULPI spec had some generic power sequencing for these
> registers we could put that into the ULPI bus layer and power up
> the device before reading the ID registers. Unfortunately this
> doesn't exist and the power sequence is usually device specific.
> By having the device matched up with DT we can avoid this
> problem."
> 
> But as is, the code now requires a DT when there is a power
> sequencing issue, which is wrong for Merrifield. It seems my patch
> breaks the OF path, by replacing that by a deferred probe.
> 
> I'm thinking the correct way would be:
> - if present use DT
> - else if test write fails, defer probe
> - else enumeration by reading the vendor ID and product ID registers
> 

I think this patch should be reverted until a better solution is found.
After all, at this point it is effectively unknown if there are other
users (besides devicetree) depending on ulpi_read_id() returning 0 if
the communication with the device fails.

Guenter
