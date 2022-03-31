Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5C44EDE73
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 18:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbiCaQOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 12:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbiCaQOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 12:14:40 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10521D59D8;
        Thu, 31 Mar 2022 09:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648743173; x=1680279173;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FZgzdZcxCZ1pvLN2PUSZ0qsm/sXsOBfkSy9XeCnr8gc=;
  b=cm6xF1dFe8m3rok8k44PBbvsxMZuvT6yp7gc6AZ4z49+VIJ0NWx/LAj8
   cP3l2W7hpt+Tbd6J8OC7uWD+zECvqP3G/uFqOQIjxy3EwQvKV8hLQMw9t
   gnLX1QDZ8pYUp4htYY323g5D28pUAL4VS3YCgrVz0a+8zl+cEoPGFSyic
   tSO+g3gDpfUNcu1WpKsyH6w7+I2587cfiYC9TLO7urJMQ8T4J9tVzXoWt
   xtDk5w5NLDoxpOXOcUjLQRYGnDR8OlHOxzvVLsLbuFaE0iOevxxnCxc5s
   3EW6/YFox3BjC3qvmqBlTfbuzuDh6WnYQL8mQRylKDcjo+/9DdYby4u5B
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="258713667"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="258713667"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 09:12:36 -0700
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="522403605"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.162])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 09:12:31 -0700
Received: by lahna (sSMTP sendmail emulation); Thu, 31 Mar 2022 19:10:20 +0300
Date:   Thu, 31 Mar 2022 19:10:20 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Benson Leung <bleung@google.com>
Cc:     Takashi Iwai <tiwai@suse.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Won Chung <wonchung@google.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Benson Leung <bleung@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] sound/hda: Add NULL check to component match callback
 function
Message-ID: <YkXSbPG+PuyGub2V@lahna>
References: <s5hzgl6eg48.wl-tiwai@suse.de>
 <CAOvb9yiO_n48JPZ3f0+y-fQ_YoOmuWF5c692Jt5_SKbxdA4yAw@mail.gmail.com>
 <s5hr16ieb8o.wl-tiwai@suse.de>
 <YkVzl4NEzwDAp/Zq@kuha.fi.intel.com>
 <s5hmth6eaiz.wl-tiwai@suse.de>
 <YkV1rsq1SeTNd8Ud@kuha.fi.intel.com>
 <s5hk0cae9pw.wl-tiwai@suse.de>
 <s5h7d8adzdl.wl-tiwai@suse.de>
 <s5hzgl6ciho.wl-tiwai@suse.de>
 <YkXJr2KhSzHJHxRF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkXJr2KhSzHJHxRF@google.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Mar 31, 2022 at 08:33:03AM -0700, Benson Leung wrote:
> > --- a/sound/hda/hdac_i915.c
> > +++ b/sound/hda/hdac_i915.c
> > @@ -102,18 +102,13 @@ static int i915_component_master_match(struct device *dev, int subcomponent,
> >  	struct pci_dev *hdac_pci, *i915_pci;
> >  	struct hdac_bus *bus = data;
> >  
> > -	if (!dev_is_pci(dev))
> > +	if (subcomponent != I915_COMPONENT_AUDIO || !dev_is_pci(dev))
> >  		return 0;
> >  
> 
> If I recall this bug correctly, it's not the usb port perse that is falling
> through this !dev_is_pci(dev) check, it's actually the usb4-port in a new
> proposed patch by Heikki and Mika to extend the usb type-c component to
> encompass the usb4 specific pieces too. Is it possible usb4 ports are considered
> pci devices, and that's how we got into this situation?

For usb4_port the dev_ic_pci(dev) returns false:

  #define dev_is_pci(d) ((d)->bus == &pci_bus_type)

We don't attach them to PCI bus (well they are not PCI devices).
