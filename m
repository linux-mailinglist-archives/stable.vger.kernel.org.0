Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CFE650B47
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 13:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiLSMSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 07:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiLSMSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 07:18:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01053E4A;
        Mon, 19 Dec 2022 04:18:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 904CF60F26;
        Mon, 19 Dec 2022 12:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664ADC433D2;
        Mon, 19 Dec 2022 12:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671452283;
        bh=3Abw710UXrDt/s6OKArjDnvrdscxZZG36Ti2zptfupw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gBMkkauR9b4nvpxJWcfED3tL8kmnRVY0QnDKPWjimTUqT30OhpZbvpDOmC22YBwlg
         WKUn65k30nsPAbU6cZAIvGKe+NAV4acXosVx1zLE7m3WcXfn9ynzUWMzPLODgpxkIA
         qel4kqAZZJ1/NFAlv32NV/exVJImoYo3PDhnYLEw=
Date:   Mon, 19 Dec 2022 13:18:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     FRANJOU Stephane <stephane.franjou@csgroup.eu>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Tony Jones <tonyj@suse.de>,
        Jiri Olsa <jolsa@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Seeteena Thoufeek <s1seetee@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] [Backport for 4.14] perf script python: Remove explicit
 shebang from tests/attr.c
Message-ID: <Y6BWeFdJiz/tIhQ6@kroah.com>
References: <3ca0515edb717e0f394f973f3cbbe2c80abb35e4.1671190496.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ca0515edb717e0f394f973f3cbbe2c80abb35e4.1671190496.git.christophe.leroy@csgroup.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 12:38:12PM +0100, Christophe Leroy wrote:
> From: Tony Jones <tonyj@suse.de>
> 
> [Upstream commit d72eadbc1d2866fc047edd4535ffb0298fe240be]
> 
> tests/attr.c invokes attr.py via an explicit invocation of Python
> ($PYTHON) so there is therefore no need for an explicit shebang.
> 
> Also most distros follow pep-0394 which recommends that /usr/bin/python
> refer only to v2 and so may not exist on the system (if PYTHON=python3).
> 
> Signed-off-by: Tony Jones <tonyj@suse.de>
> Acked-by: Jiri Olsa <jolsa@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> Cc: Seeteena Thoufeek <s1seetee@linux.vnet.ibm.com>
> Link: http://lkml.kernel.org/r/20190124005229.16146-5-tonyj@suse.de
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> ---
>  tools/perf/tests/attr.py | 1 -
>  1 file changed, 1 deletion(-)

Why only 4.14?  What about 4.19?

thanks,

greg k-h
