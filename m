Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11FB5FF2D2
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 19:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbiJNROI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 13:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiJNROH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 13:14:07 -0400
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578441CB52F;
        Fri, 14 Oct 2022 10:14:06 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 682605801B3;
        Fri, 14 Oct 2022 13:14:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 14 Oct 2022 13:14:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1665767645; x=1665771245; bh=v2xtyFESI3
        AU0yurgsvnGP78lRm7Qux9muzHiKFWjKs=; b=NYn2d4ZIt0sZnULJUkcoyQ8Ikw
        6MQQX/gJKQIvOtHTt8J3DgRNSVMpSceZ3CdnGfVVrSxESiznwEo2lvDSY13Pf/lQ
        aY0A2oI19viw0ZKnimzTIzjB0X93hBl6xec/iy6Qqi5eFyu3rBKOuVFWCKwvIpLE
        qRQ+lWXgHNmS8xK2iHRaAmge8iUbhOXQAEXVm7Tv9lztzslRMjxKmqgI6A7mWeIc
        4mn2gpd0R4CzRhvj9O+t3dgYWY6hFA59ldThsQKEi6guRuTdo03uO/9I0s8hTU9B
        fFjnR06m3omyR+s9hIZ8arKbFD4k3Y2pm/K6puVGwif5px1KZbjouiMy7C5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1665767645; x=1665771245; bh=v2xtyFESI3AU0yurgsvnGP78lRm7
        Qux9muzHiKFWjKs=; b=JjRZmMahHBIYt359JEHGhFsuYoT08KO1lCJ5TaZKiDQE
        n7BthrpykGDrT9cL4dzZtnZuOQYkmJ6wlsieHuF+VEil4rAVrtJk0/GyBmbVxjn9
        ItaovVwOyP2mz6AnmF0WcgFs9RqOwKGcoHs01vz5eiUaq7lLdRdiRsDZkc3Cy5JW
        136HjHoHhxHRNDjp8n3fRahdhSzkIr+YXRtLyVtWYJe1NgdHDSwnrZBnbeY2XvOX
        LpaZIytanIgl+iM5eiYxaJLgxe24JYml/SZUuPfIOo0SRhUcQ2j6BZDJvbZRBMpe
        DfRwVaWtrDZv9lRjzTcT4/drCcyg4Aey7JO5ev4Vxg==
X-ME-Sender: <xms:3JhJY-lhdKaoB1jW7sAhIpArnfUH_oMuHDUhuFejKDZbP2CH7l6U6g>
    <xme:3JhJY10iRwiI7wtDY60Md8uopR63m3puhSKNJGLcdPF3FGtaHfMfl4ewX0XAXPWMM
    hMS4RmK-D9SkUBh37Q>
X-ME-Received: <xmr:3JhJY8qHRbpJ0cmN7BPROzJZWRf8vv0B6o3eqn5fuNaz0uQ_e79Eahqn9DE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeekvddgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefvhihl
    vghrucfjihgtkhhsuceotghouggvsehthihhihgtkhhsrdgtohhmqeenucggtffrrghtth
    gvrhhnpefggeekieffteehgfetffduhfefjeehvdejhfejkeduleffudelhfefkeeiledu
    jeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheptghouggvsehthihhihgtkhhsrdgtohhm
X-ME-Proxy: <xmx:3ZhJYym5tWYTKMzAjZ0Yjs6L9jXoWGraoWRzf1PNnw3_CB2Ubt-TTw>
    <xmx:3ZhJY81wynsmR0kDM83y_TiiWvaVjSvUM0bpNcwilrYAJS_fCB7vvQ>
    <xmx:3ZhJY5vRbNoab6tjXrTsilYlzkGhyYyg1SRd5OWqQNSAuSuH0DUc2A>
    <xmx:3ZhJY9n94Qzb9By0mmCTfFdg8ZDwTVWJMiE79d3zhORyNEwWxMgpJg>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Oct 2022 13:14:04 -0400 (EDT)
Date:   Fri, 14 Oct 2022 12:13:48 -0500
From:   Tyler Hicks <code@tyhicks.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH v2] Documentation: process: replace outdated LTS table w/
 link
Message-ID: <20221014171348.w5t4lwwqaqmfykta@sequoia>
References: <Y0mSVQCQer7fEKgu@kroah.com>
 <20221014171040.849726-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014171040.849726-1-ndesaulniers@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-10-14 10:10:40, Nick Desaulniers wrote:
> The existing table was a bit outdated.
> 
> 3.16 was EOL in 2020.
> 4.4 was EOL in 2022.
> 
> 5.10 is new in 2020.
> 5.15 is new in 2021.
> 
> We'll see if 6.1 becomes LTS in 2022.
> 
> Rather than keep this table updated, it does duplicate information from
> multiple kernel.org pages. Make one less duplication site that needs to
> be updated and simply refer to the kernel.org page on releases.
> 
> Suggested-by: Tyler Hicks <code@tyhicks.com>
> Suggested-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Changes v1 -> v2:
> * Rather than update table, use a link as per Tyler and Bagas.
> * Carry forward GKH's SB tag.

Thanks! Was just about to send out that same thing. :)

Reviewed-by: Tyler Hicks (Microsoft) <code@tyhicks.com>

Tyler

> 
>  Documentation/process/2.Process.rst | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/process/2.Process.rst b/Documentation/process/2.Process.rst
> index e05fb1b8f8b6..6a919cffcbfd 100644
> --- a/Documentation/process/2.Process.rst
> +++ b/Documentation/process/2.Process.rst
> @@ -126,17 +126,10 @@ than one development cycle past their initial release. So, for example, the
>  5.2.21 was the final stable update of the 5.2 release.
>  
>  Some kernels are designated "long term" kernels; they will receive support
> -for a longer period.  As of this writing, the current long term kernels
> -and their maintainers are:
> -
> -	======  ================================	=======================
> -	3.16	Ben Hutchings				(very long-term kernel)
> -	4.4	Greg Kroah-Hartman & Sasha Levin	(very long-term kernel)
> -	4.9	Greg Kroah-Hartman & Sasha Levin
> -	4.14	Greg Kroah-Hartman & Sasha Levin
> -	4.19	Greg Kroah-Hartman & Sasha Levin
> -	5.4	Greg Kroah-Hartman & Sasha Levin
> -	======  ================================	=======================
> +for a longer period.  Please refer to the following link for the list of active
> +long term kernel versions and their maintainers:
> +
> +	https://www.kernel.org/category/releases.html
>  
>  The selection of a kernel for long-term support is purely a matter of a
>  maintainer having the need and the time to maintain that release.  There
> 
> base-commit: 9c9155a3509a2ebdb06d77c7a621e9685c802eac
> -- 
> 2.38.0.413.g74048e4d9e-goog
> 
