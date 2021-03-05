Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C4332E2AE
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 08:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhCEHBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 02:01:33 -0500
Received: from mout.gmx.net ([212.227.17.21]:34269 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhCEHBd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 02:01:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614927689;
        bh=bcPSjtvBjV/wuZLKZ4YScZtE3E5elRVLF3pSevBObUs=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=g75Krn27s6SAWkdYbCGK46PKCxarkBy1PeETGgkA7OnXIW5U9tsZc8gPM4oMO01oW
         t/xekUexW28A7dDgeGlcF2KnESzWWd6bsagb208FLH69IpropcpRxLa8T1y1WQS01p
         q1Jw9oglbUfQPcgkjUC3uqZ6H2W5g9m3b6qJCt9k=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.fritz.box ([185.146.51.102]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1McpNy-1lrgCJ3DE2-00ZthS; Fri, 05
 Mar 2021 08:01:29 +0100
Message-ID: <68a32005c45cf0710676c547b6297c83357c95c9.camel@gmx.de>
Subject: Re: Linux 5.10.20
From:   Mike Galbraith <efault@gmx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Date:   Fri, 05 Mar 2021 08:01:29 +0100
In-Reply-To: <YEHTjCVIoXW1PciT@kroah.com>
References: <1614855672230162@kroah.com>
         <4dac43f81dc390faa6e62de39ade373851dd6b84.camel@gmx.de>
         <YEHTjCVIoXW1PciT@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:PavxRB/1sG6QfiJhWT6IbA7azFxAT8PXScCy5hMf7tgR4T5JluT
 jx6cen1tOqx9aAaje7e4J+0BxYbRMnRQ3RB3Vl7hStpNk3XyEXIHRGqnuHrIsbIOYyA2ksN
 Opdlaif+VDdzYzVM+29/FO5S62HyfNM7V7rn9TAlX4hMlGcVQvqT8TKFh6Ko0/rRNkDCZYg
 BXkl+aHpmnncX/yMV47Pw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:puBGZHcYtcg=:/RduWMaVvEZb/it5SEGlxD
 nRvWn6+YaElE6Gi0rcxuErGsCB3ObMP4jbCOwbFbW2AlWXwBy6YBuSblyP6n8CxzUqr7Llar+
 Up2tcRmJWqei9ba559UIJNviTVN+OVKvnDe9EE8R6/yqISnqRNu++rej71a3v9g1AvMTjrKR6
 VRg6h/VLJVUfKT2RyE123JUUDR40y1d7YJIUcP4qR3vo/hWazjy1Hy3U2nzNm308I0jzy03CC
 v5iaW/iHOxjr+T7NOU/fIJRoE/WOMn16SDunQsodNItOR+nZ9eey8sDANnxaxeVHJecxvIsuG
 UAswM3XtdPJ5grCG3pj1ZBAWbCjyyXyfLtj6SG2Aq7VCzrol9Cv/KqWzaXAtM4p6zcslcMaIa
 g9aYnwfua0FAscfJgf7mXp473e5S+X1r5M6vj+H5oPmqYOiwQFCQBo1+uvVLvtHIkfxN5ZKTH
 1KtEa8qvZD7v/8xSPU/Rrj5IaMOgxQQtdw6z3uVW7gQOj40WhPTLgpsEVBRZvLVzwy3fMKRQr
 8791Vrmb7lW2qAVGW8sjGmPf6wttp3Ng0HMUHPC9XXARY+gwgUzMqEiaDNE3C+DIF+tOgB8cf
 XxmeXIaPjMLU3cZAsPgS4dJIzgxrktdPupD+gQvp+qDxWOpTjXnQq6XUvHnj244rW2fKX4LGk
 MH3pf6cK9iWhO8q3VQunUVaZ1xedeXfY708hVkEn1ssUNPYfWe8+EV39yE6aZqvxTMNSHJypP
 SAHdQUqasg2aGioSfF96leUD+/KIars6JCtioZfAzM+gIo/2/4dYSrVSR6PZLO4kavtcDAxFN
 CidY3YEP2KIGlhi9crbHBTKPPh01rGwFNuAQVadxKGROqe2fwBm6gt4ZUphUrwC9LBdv3MgmG
 b+JFSQkX5IPWILRjDdaQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-03-05 at 07:45 +0100, Greg Kroah-Hartman wrote:
> On Fri, Mar 05, 2021 at 04:16:36AM +0100, Mike Galbraith wrote:
>
> > eb9036b4cf4c0 =3D=3D 8a8109f303e2 upstream, and accidentally duplicate=
d
> > most of printk_safe_flush_on_panic().

bzzt.

> I'm sorry, but I do not know what you are trying to say here at all.
> What am I supposed to do?

Never mind.  -ETOOMANYTREES

	-Mike

