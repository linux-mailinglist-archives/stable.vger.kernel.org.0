Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE0B1B3154
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 22:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgDUUkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 16:40:02 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:57374 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725850AbgDUUkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 16:40:01 -0400
X-Greylist: delayed 1598 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Apr 2020 16:40:00 EDT
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jQzHO-000Mvn-Aj; Tue, 21 Apr 2020 23:14:03 +0300
Message-ID: <404251406c2053b0717af483da50ae04e7be79e3.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Sasha Levin <sashal@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 21 Apr 2020 23:14:01 +0300
In-Reply-To: <20200421195612.7E5D42074F@mail.kernel.org>
References: <iwlwifi.20200417100405.98a79be2db6a.I3a4af6b03b87a6bc18db9b1ff9a812f397bee1fc@changeid>
         <20200421195612.7E5D42074F@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP autolearn=ham autolearn_force=no version=3.4.4
Subject: Re: [PATCH v2 v5.7 4/6] iwlwifi: mvm: limit maximum queue
 appropriately
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-04-21 at 19:56 +0000, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: 4.9+
> 
> The bot has tested the following trees: v5.6.5, v5.5.18, v5.4.33, v4.19.116, v4.14.176, v4.9.219.
> 
> v5.6.5: Build OK!
> v5.5.18: Build OK!
> v5.4.33: Build OK!
> v4.19.116: Failed to apply! Possible dependencies:
>     1169310fa9a8 ("iwlwifi: refactor txq_alloc for supporting more command type")
>     2d8c261511ab ("iwlwifi: add d3 debug data support")
>     718a8b23ad04 ("iwlwifi: unite macros with same meaning")
>     8093bb6d4fee ("iwlwifi: add PCI IDs for the 22260 device series")
>     99448a8c1145 ("iwlwifi: mvm: move queue management into sta.c")
>     9b3089bd820d ("iwlwifi: pcie: allow using tx init for other queues but the command queue")
>     a98e2802a654 ("iwlwifi: correct one of the PCI struct names")
>     afc1e3b4fc8f ("iwlwifi: mvm: use correct GP2 register address for 22000 family")
>     b998fbbd531f ("iwlwifi: implement BISR HW workaround for 22260 devices")
>     c30aef01bae9 ("iwlwifi: set 512 TX queue slots for AX210 devices")
>     c96b5eec2105 ("iwlwifi: refactor NIC init sequence")
>     cefec29ebdde ("iwlwifi: pcie: align licensing to dual GPL/BSD")
>     ff911dcaa2e4 ("iwlwifi: introduce device family AX210")
> 
> v4.14.176: Failed to apply! Possible dependencies:
>     0e1be40a45d7 ("iwlwifi: mvm: allow reading UMAC error data from SMEM in A000 devices")
>     251985c92865 ("iwlwifi: mvm: use shorter queues for mgmt and auxilary queues")
>     2ee824026288 ("iwlwifi: pcie: support context information for 22560 devices")
>     2f7a3863191a ("iwlwifi: rename the temporary name of A000 to the official 22000")
>     33708052993c ("iwlwifi: add support for 22560 devices")
>     3485e76e7349 ("iwlwifi: define minimum valid address for umac_error_event_table in cfg")
>     5369774c84ea ("iwlwifi: add TX queue size parameter to TX queue allocation")
>     718a8b23ad04 ("iwlwifi: unite macros with same meaning")
>     8093bb6d4fee ("iwlwifi: add PCI IDs for the 22260 device series")
>     80b0ebd488b3 ("Merge tag 'iwlwifi-next-for-kalle-2017-11-29' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next")
>     ab27926d9e4a ("iwlwifi: fix devices with PCI Device ID 0x34F0 and 11ac RF modules")
>     cb8550e15bd1 ("iwlwifi: fix multi queue notification for a000 devices")
>     dd05f9aab442 ("iwlwifi: pcie: dynamic Tx command queue size")
>     e59a00f48848 ("iwlwifi: fix indentation in a000 family configuration")
>     fb5b28469d2a ("iwlwifi: mvm: move umac_error_event_table validity check to where it's set")
>     ff911dcaa2e4 ("iwlwifi: introduce device family AX210")
> 
> v4.9.219: Failed to apply! Possible dependencies:
>     01796ff2fa6e ("iwlwifi: mvm: always free inactive queue when moving ownership")
>     0aaece81114e ("iwlwifi: split firmware API from iwl-trans.h")
>     1ea423b0e047 ("iwlwifi: remove unnecessary dev_cmd_headroom parameter")
>     310181ec34e2 ("iwlwifi: move to TVQM mode")
>     5594d80e9bf4 ("iwlwifi: support two phys for a000 devices")
>     623e7766be90 ("iwlwifi: pcie: introduce split point to a000 devices")
>     65e254821cee ("iwlwifi: mvm: use firmware station PM notification for AP_LINK_PS")
>     6b35ff91572f ("iwlwifi: pcie: introduce a000 TX queues management")
>     727c02dfb848 ("iwlwifi: pcie: cleanup rfkill checks")
>     8236f7db2724 ("iwlwifi: mvm: assign cab queue to the correct station")
>     87d0e1af9db3 ("iwlwifi: mvm: separate queue mapping from queue enablement")
>     bb49701b41de ("iwlwifi: mvm: support a000 SCD queue configuration")
>     cf90da352a32 ("iwlwifi: mvm: use mvm_disable_queue instead of sharing logic")
>     d172a5eff629 ("iwlwifi: reorganize firmware API")
>     df88c08d5c7e ("iwlwifi: mvm: release static queues on bcast release")
>     eda50cde58de ("iwlwifi: pcie: add context information support")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Same thing as with the other patches: We definitely don't want all
these dependencies.  Some functions were moved around and that's what's
causing the failures.  I'll rebase this patch for those kernels where
it failed and submit separately.

--
Luca.

