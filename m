Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F73D6B7D07
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 17:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjCMQIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 12:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjCMQIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 12:08:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49F972005;
        Mon, 13 Mar 2023 09:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678723723; x=1710259723;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KwWw08/eWY4G9C519WQB8MadkSavHLvHsQC/LhwmTtk=;
  b=caORXnjeqLN1ufIu42HoNR10u2Dkt1E/oT2k9+lRoh5aE8DAszoT2H64
   66C7lJ9ubvaXEqSO9nmejrZ4I8/hOxKWRO19FOipRDLi5NQwxKFQsgnQU
   SdCSfPNwBduWqrfoMB+IBnkT/vDyEofKbVx7kF8U7oFBlSYt9lZbHlh3l
   pnnbLCZwsRC9+DYqeJkIz/yxp96iby/E+EA3HLeZSibcoJJhUgZGkjzdM
   gz5ILm3C7hs7j3JKIiqg4kcpQpij53NPn67UZzeb5VpVNwY8GsAi0fWvJ
   0fw4GwROupP3GEJnniovxxX0jS8rbIhghGhYRuI/FBgFFBbOJ1xjNh+9o
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338736597"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338736597"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 09:05:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="671949770"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="671949770"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 13 Mar 2023 09:05:29 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pbkfw-0005rQ-1I;
        Mon, 13 Mar 2023 16:05:28 +0000
Date:   Tue, 14 Mar 2023 00:04:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marek Vasut <marex@denx.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Cc:     oe-kbuild-all@lists.linux.dev, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: usbc-tusb320: unregister typec port on driver
 removal
Message-ID: <202303132335.Qnq7apal-lkp@intel.com>
References: <20230313130105.4183296-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313130105.4183296-1-alvin@pqrs.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Alvin,

I love your patch! Perhaps something to improve:

[auto build test WARNING on chanwoo-extcon/extcon-next]
[also build test WARNING on linus/master v6.3-rc2 next-20230310]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alvin-ipraga/extcon-usbc-tusb320-unregister-typec-port-on-driver-removal/20230313-210245
base:   https://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git extcon-next
patch link:    https://lore.kernel.org/r/20230313130105.4183296-1-alvin%40pqrs.dk
patch subject: [PATCH] extcon: usbc-tusb320: unregister typec port on driver removal
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230313/202303132335.Qnq7apal-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/fe414069d19f6d59c7c34f820459f4114e2de136
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Alvin-ipraga/extcon-usbc-tusb320-unregister-typec-port-on-driver-removal/20230313-210245
        git checkout fe414069d19f6d59c7c34f820459f4114e2de136
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303132335.Qnq7apal-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/extcon/extcon-usbc-tusb320.c: In function 'tusb320_typec_probe':
>> drivers/extcon/extcon-usbc-tusb320.c:429:13: warning: statement with no effect [-Wunused-value]
     429 |         priv->connector_fwnode;
         |         ~~~~^~~~~~~~~~~~~~~~~~


vim +429 drivers/extcon/extcon-usbc-tusb320.c

   379	
   380	static int tusb320_typec_probe(struct i2c_client *client,
   381				       struct tusb320_priv *priv)
   382	{
   383		struct fwnode_handle *connector;
   384		const char *cap_str;
   385		int ret;
   386	
   387		/* The Type-C connector is optional, for backward compatibility. */
   388		connector = device_get_named_child_node(&client->dev, "connector");
   389		if (!connector)
   390			return 0;
   391	
   392		/* Type-C connector found. */
   393		ret = typec_get_fw_cap(&priv->cap, connector);
   394		if (ret)
   395			goto err_put;
   396	
   397		priv->port_type = priv->cap.type;
   398	
   399		/* This goes into register 0x8 field CURRENT_MODE_ADVERTISE */
   400		ret = fwnode_property_read_string(connector, "typec-power-opmode", &cap_str);
   401		if (ret)
   402			goto err_put;
   403	
   404		ret = typec_find_pwr_opmode(cap_str);
   405		if (ret < 0)
   406			goto err_put;
   407	
   408		priv->pwr_opmode = ret;
   409	
   410		/* Initialize the hardware with the devicetree settings. */
   411		ret = tusb320_set_adv_pwr_mode(priv);
   412		if (ret)
   413			goto err_put;
   414	
   415		priv->cap.revision		= USB_TYPEC_REV_1_1;
   416		priv->cap.accessory[0]		= TYPEC_ACCESSORY_AUDIO;
   417		priv->cap.accessory[1]		= TYPEC_ACCESSORY_DEBUG;
   418		priv->cap.orientation_aware	= true;
   419		priv->cap.driver_data		= priv;
   420		priv->cap.ops			= &tusb320_typec_ops;
   421		priv->cap.fwnode		= connector;
   422	
   423		priv->port = typec_register_port(&client->dev, &priv->cap);
   424		if (IS_ERR(priv->port)) {
   425			ret = PTR_ERR(priv->port);
   426			goto err_put;
   427		}
   428	
 > 429		priv->connector_fwnode;
   430	
   431		return 0;
   432	
   433	err_put:
   434		fwnode_handle_put(connector);
   435	
   436		return ret;
   437	}
   438	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
