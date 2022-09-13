Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF745B6776
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 07:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiIMFne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 01:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiIMFnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 01:43:31 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08BE57227
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 22:43:30 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28D5Sbkb028582;
        Tue, 13 Sep 2022 05:43:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=qcppdkim1; bh=Plc9WRxWy6CZQF4VjMiLDLKiQHVNGoNQCf+eqc0HDtI=;
 b=A96tintGrt+3fnP1rGw8/QPhxwESGc/MnhENhEHCbh8C/dTvmyrrkzTRRBKM6ac4tYdB
 4D/IHNeSeSYxLqch1bKhDF9GfmPTzsMQYE2Gldwie9WHzCcUz9QXndXxU3dc1n67Kw18
 /v0S2+RHc5w3AGnKSDeVK/fh3VtNh5aRSscOeQNlfqHVo6IX441g41ZmSN790F7OyxWp
 czMV49SsOPLXglPpWTD7kf4k94QzOu9Q9YIeiCTaT3TUldycUxWDPc1dT1BFou4mK9jc
 7bOEoMHaIJ2L5fnKagkVRlX/OoG2Ki2g6SQH4jun1VGAnYgN5W3ubauy0qlRi1oW8T4Q kA== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jjh9tgc8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 05:43:24 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 28D5hOqS029458
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 05:43:24 GMT
Received: from jackp-linux.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 12 Sep 2022 22:43:23 -0700
Date:   Mon, 12 Sep 2022 22:43:06 -0700
From:   Jack Pham <quic_jackp@quicinc.com>
To:     <gregkh@linuxfoundation.org>
CC:     <jleng@ambarella.com>, <stable@kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] usb: gadget: f_uac2: fix superspeed
 transfer" failed to apply to 5.15-stable tree
Message-ID: <20220913054306.GA31201@jackp-linux.qualcomm.com>
References: <1662463814122169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1662463814122169@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: RdrNlOFiz0LhDla2Rot6V5W23mZKhL8W
X-Proofpoint-GUID: RdrNlOFiz0LhDla2Rot6V5W23mZKhL8W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-13_02,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=917 spamscore=0
 priorityscore=1501 clxscore=1011 bulkscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209130025
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 01:30:14PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Ah ok, for 5.15 this patch doesn't apply due to broken indentation that
was later fixed.  So could we also backport commit 18d6b39ee895 ("usb:
gadget: f_uac2: clean up some inconsistent indenting") first or should
this patch just be fixed up to apply standalone?

Jack

> ------------------ original commit in Linus's tree ------------------
> 
> From f511aef2ebe5377d4c263842f2e0c0b8e274e8e5 Mon Sep 17 00:00:00 2001
> From: Jing Leng <jleng@ambarella.com>
> Date: Wed, 20 Jul 2022 18:48:15 -0700
> Subject: [PATCH] usb: gadget: f_uac2: fix superspeed transfer
> 
> On page 362 of the USB3.2 specification (
> https://usb.org/sites/default/files/usb_32_20210125.zip),
> The 'SuperSpeed Endpoint Companion Descriptor' shall only be returned
> by Enhanced SuperSpeed devices that are operating at Gen X speed.
> Each endpoint described in an interface is followed by a 'SuperSpeed
> Endpoint Companion Descriptor'.
> 
> If users use SuperSpeed UDC, host can't recognize the device if endpoint
> doesn't have 'SuperSpeed Endpoint Companion Descriptor' followed.
> 
> Currently in the uac2 driver code:
> 1. ss_epout_desc_comp follows ss_epout_desc;
> 2. ss_epin_fback_desc_comp follows ss_epin_fback_desc;
> 3. ss_epin_desc_comp follows ss_epin_desc;
> 4. Only ss_ep_int_desc endpoint doesn't have 'SuperSpeed Endpoint
> Companion Descriptor' followed, so we should add it.
> 
> Fixes: eaf6cbe09920 ("usb: gadget: f_uac2: add volume and mute support")
> Cc: stable <stable@kernel.org>
> Signed-off-by: Jing Leng <jleng@ambarella.com>
> Signed-off-by: Jack Pham <quic_jackp@quicinc.com>
> Link: https://lore.kernel.org/r/20220721014815.14453-1-quic_jackp@quicinc.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
> index 1905a8d8e0c9..08726e4c68a5 100644
> --- a/drivers/usb/gadget/function/f_uac2.c
> +++ b/drivers/usb/gadget/function/f_uac2.c
> @@ -291,6 +291,12 @@ static struct usb_endpoint_descriptor ss_ep_int_desc = {
>  	.bInterval = 4,
>  };
>  
> +static struct usb_ss_ep_comp_descriptor ss_ep_int_desc_comp = {
> +	.bLength = sizeof(ss_ep_int_desc_comp),
> +	.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
> +	.wBytesPerInterval = cpu_to_le16(6),
> +};
> +
>  /* Audio Streaming OUT Interface - Alt0 */
>  static struct usb_interface_descriptor std_as_out_if0_desc = {
>  	.bLength = sizeof std_as_out_if0_desc,
> @@ -604,7 +610,8 @@ static struct usb_descriptor_header *ss_audio_desc[] = {
>  	(struct usb_descriptor_header *)&in_feature_unit_desc,
>  	(struct usb_descriptor_header *)&io_out_ot_desc,
>  
> -  (struct usb_descriptor_header *)&ss_ep_int_desc,
> +	(struct usb_descriptor_header *)&ss_ep_int_desc,
> +	(struct usb_descriptor_header *)&ss_ep_int_desc_comp,
>  
>  	(struct usb_descriptor_header *)&std_as_out_if0_desc,
>  	(struct usb_descriptor_header *)&std_as_out_if1_desc,
> @@ -800,6 +807,7 @@ static void setup_headers(struct f_uac2_opts *opts,
>  	struct usb_ss_ep_comp_descriptor *epout_desc_comp = NULL;
>  	struct usb_ss_ep_comp_descriptor *epin_desc_comp = NULL;
>  	struct usb_ss_ep_comp_descriptor *epin_fback_desc_comp = NULL;
> +	struct usb_ss_ep_comp_descriptor *ep_int_desc_comp = NULL;
>  	struct usb_endpoint_descriptor *epout_desc;
>  	struct usb_endpoint_descriptor *epin_desc;
>  	struct usb_endpoint_descriptor *epin_fback_desc;
> @@ -827,6 +835,7 @@ static void setup_headers(struct f_uac2_opts *opts,
>  		epin_fback_desc = &ss_epin_fback_desc;
>  		epin_fback_desc_comp = &ss_epin_fback_desc_comp;
>  		ep_int_desc = &ss_ep_int_desc;
> +		ep_int_desc_comp = &ss_ep_int_desc_comp;
>  	}
>  
>  	i = 0;
> @@ -855,8 +864,11 @@ static void setup_headers(struct f_uac2_opts *opts,
>  	if (EPOUT_EN(opts))
>  		headers[i++] = USBDHDR(&io_out_ot_desc);
>  
> -	if (FUOUT_EN(opts) || FUIN_EN(opts))
> +	if (FUOUT_EN(opts) || FUIN_EN(opts)) {
>  		headers[i++] = USBDHDR(ep_int_desc);
> +		if (ep_int_desc_comp)
> +			headers[i++] = USBDHDR(ep_int_desc_comp);
> +	}
>  
>  	if (EPOUT_EN(opts)) {
>  		headers[i++] = USBDHDR(&std_as_out_if0_desc);
> 
