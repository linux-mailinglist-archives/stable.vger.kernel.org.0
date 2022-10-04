Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8655F48DC
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 19:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiJDRqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 13:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiJDRqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 13:46:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F414AD4B;
        Tue,  4 Oct 2022 10:46:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37635B81B41;
        Tue,  4 Oct 2022 17:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B327C433D6;
        Tue,  4 Oct 2022 17:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664905558;
        bh=mEuhiXpELJARb7beXplRVX/+gd88BFbLzWSWad5oX8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eDoUJN3Dk4zk4dFGhDVajXkCiOsVyfOlFNLKutOqnS0yZPN7S2hiRD/8aZFg57Dv1
         pRzqnuTzSdvB5UnX9mZzlZJGsUyExJtBKbdsMMeKPXawisnLKquKXqUFghZyNYQwgU
         DhEl72pDN/A+LsCppq7Jhy3uJGa0tnP/zbFXq55o=
Date:   Tue, 4 Oct 2022 19:45:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/83] 5.15.72-rc1 review
Message-ID: <YzxxVJqph3iOHcdb@kroah.com>
References: <20221003070721.971297651@linuxfoundation.org>
 <e7934bdb-fb0a-76cd-0fd2-f9b8da03170d@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7934bdb-fb0a-76cd-0fd2-f9b8da03170d@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 07:26:40AM -0700, Guenter Roeck wrote:
> On 10/3/22 00:10, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.72 release.
> > There are 83 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> > Anything received after that time might be too late.
> > 
> 
> perf fails to build.
> 
> In file included from util/evlist.h:13,
>                  from builtin-annotate.c:21:
> util/evsel.h:266:38: error: ‘PERF_TOOL_MAX’ undeclared here (not in a function); did you mean ‘PERF_TXN_MAX’?
>   266 | extern const char *evsel__tool_names[PERF_TOOL_MAX];
>       |                                      ^~~~~~~~~~~~~
>       |                                      PERF_TXN_MAX
> In file included from util/hist.h:8,
>                  from builtin-diff.c:13:
> util/evsel.h:266:38: error: ‘PERF_TOOL_MAX’ undeclared here (not in a function); did you mean ‘PERF_TXN_MAX’?
>   266 | extern const char *evsel__tool_names[PERF_TOOL_MAX];
>       |                                      ^~~~~~~~~~~~~
>       |                                      PERF_TXN_MAX
> In file included from util/evlist.h:13,
>                  from builtin-evlist.c:11:
> util/evsel.h:266:38: error: ‘PERF_TOOL_MAX’ undeclared here (not in a function); did you mean ‘PERF_TXN_MAX’?
>   266 | extern const char *evsel__tool_names[PERF_TOOL_MAX];
>       |                                      ^~~~~~~~~~~~~
>       |                                      PERF_TXN_MAX
> In file included from tools/perf/util/evlist.h:13,
>                  from builtin-ftrace.c:24:
> tools/perf/util/evsel.h:266:38: error: ‘PERF_TOOL_MAX’ undeclared here (not in a function); did you mean ‘PERF_TXN_MAX’?
>   266 | extern const char *evsel__tool_names[PERF_TOOL_MAX];
>       |                                      ^~~~~~~~~~~~~
>       |                                      PERF_TXN_MAX
> builtin-annotate.c: In function ‘cmd_annotate’:
> builtin-annotate.c:594:8: error: implicit declaration of function ‘symbol__validate_sym_arguments’ [-Werror=implicit-function-declaration]
>   594 |  ret = symbol__validate_sym_arguments();
>       |        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Thanks, I've dropped all perf patches from the 5.15 queue right now as
they seem to have been added incorrectly.

That being said, I can't build perf for 5.15.y now anyway, so something
older must have broken my system, glad it's building for you...

thanks

greg k-h
