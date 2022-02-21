Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8034BD346
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 02:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245538AbiBUB5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 20:57:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245530AbiBUB5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 20:57:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5744F100C;
        Sun, 20 Feb 2022 17:56:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E71F261003;
        Mon, 21 Feb 2022 01:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDE7C340E8;
        Mon, 21 Feb 2022 01:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645408598;
        bh=yq/OsN2UPgPqkLWDnB90Fn+UbNTw+6x3zjF9s9FDhHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gC1VEDneoqZafgZU9gPv/kjrpPE2aYhKDXHjRda0CzsDlYrlPKRz/afdK5Wfvp4Hp
         5/VYBmczFIQ9ec5pgbcLkhNT699e4rqY75++9l+EOHp0eaQFECBA0IbIKbRafiEZwN
         A9lTUjj7PRL3x6py6peO6hiigXCVLbz5KFl1s14NOs+ZqNp6oYAzAsKq0j0awIjPnR
         cKEn1X88kEp+v6zixbbTdrkjAxGDo/ZkPJRotBc85wPMn5EtM6wlTXN/4trJRhQXML
         elIy55vz3FZa2YbWYi2SHZROEU2dZ0wnLlRm7TBI/Wb4ZH+X8xm4LQWeIPbgwrwBLd
         H9jlp9Ijkcx2A==
Date:   Mon, 21 Feb 2022 02:57:16 +0100
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Kleikamp <dave.kleikamp@oracle.com>
Cc:     linux-kernel@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        James Bottomley <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KEYS: trusted: Avoid calling null function
 trusted_key_exit
Message-ID: <YhLxfHcCccNUAiIl@kernel.org>
References: <20220126184155.220814-1-dave.kleikamp@oracle.com>
 <YfGtVk/HQjgl1zSS@iki.fi>
 <cda221fd-6481-598f-03ba-29d0b79af8b7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cda221fd-6481-598f-03ba-29d0b79af8b7@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 11:40:23AM -0600, Dave Kleikamp wrote:
> On 1/26/22 2:21PM, Jarkko Sakkinen wrote:
> > On Wed, Jan 26, 2022 at 12:41:55PM -0600, Dave Kleikamp wrote:
> > > If one loads and unloads the trusted module, trusted_key_exit can be
> > > NULL. Call it through static_call_cond() to avoid a kernel trap.
> > > 
> > > Fixes: 5d0682be3189 ("KEYS: trusted: Add generic trusted keys framework")
> > > 
> > > Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> > 
> > Please re-send with cc stable and the empty line removed and I'll pick it.
> 
> I re-sent a v2, but haven't seen any response from you.
> 
> I can send it again, or feel free to clean up those lines yourself.
> 
> Thanks,
> Shaggy

I've applied the patch. Thank you, and apologies for the latency.

BR, Jarkko
