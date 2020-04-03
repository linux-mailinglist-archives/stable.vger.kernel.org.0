Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 285EF19DBD9
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 18:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgDCQj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 12:39:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53544 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbgDCQj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 12:39:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033GO48e119034;
        Fri, 3 Apr 2020 16:39:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ba/j5CbMc04KuK6mlsaQvN5EhmuP6zjq0aHHSv/ALJI=;
 b=br/O1UPJeP2JGbAkX+MZVbHYoAe7v6C7Lfaj6VYknT2RlvrbE4IghWO3GFcH3x5BY8eB
 7ollf3Lu94EbI9Y9ykPYsSn4SWcJ0neeNfaFRSnuw6qF/hI/rtRXA8qdlgxmJSUvueFE
 06qAFzb++FuUZpWyow1x7g9u6pS/iM8wOzJb8W+U+WglkpNuHVBzdPEnzQecjK9aNyyT
 vSsmWx+mrbvSCcUB3GE7GnRRnIRDoFPNVhdAafaS22dLvkljAPCxjTPpkLRIVutQ9onW
 eTHIswAtG+pXM4JHJdDukHFS3oi3en6LtdL1FiaYhpjk5T4xilT+GyHvOBHTdj+unPfV HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 303cevj3x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 16:39:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033GcMZa033604;
        Fri, 3 Apr 2020 16:39:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 302ga55699-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 16:39:12 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033GdB18026063;
        Fri, 3 Apr 2020 16:39:11 GMT
Received: from [10.154.129.193] (/10.154.129.193)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 09:39:11 -0700
Subject: Re: [PATCH] nvme-fc: Revert - add module to ops template to allow
 module references
To:     James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>
References: <20200403143320.49522-1-jsmart2021@gmail.com>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <6ad66e15-4815-146a-9921-c776559e3c75@oracle.com>
Date:   Fri, 3 Apr 2020 11:38:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200403143320.49522-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1011 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=2 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030139
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/3/20 9:33 AM, James Smart wrote:
> This patch reverts the commit for
>     nvme_fc: add module to ops template to allow module references
>
> The original patch was to resolve the lldd being able to be unloaded
> while being used to talk to the boot device of the system. However, the
> end result of the original patch is that any driver unload while a nvme
> controller is live via the lldd is now being prohibited. Given the module
> reference, the module teardown routine can't be called, thus there's no
> way, other than manual actions to terminate the controllers.
>
> -- james
>
> Fixes: 863fbae929c7 ("nvme_fc: add module to ops template to allow module  references")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/nvme/host/fc.c          | 14 ++------------
>   drivers/nvme/target/fcloop.c    |  1 -
>   drivers/scsi/lpfc/lpfc_nvme.c   |  2 --
>   drivers/scsi/qla2xxx/qla_nvme.c |  1 -
>   include/linux/nvme-fc-driver.h  |  4 ----
>   5 files changed, 2 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index a8bf2fb1287b..7dfc4a2ecf1e 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -342,8 +342,7 @@ nvme_fc_register_localport(struct nvme_fc_port_info *pinfo,
>   	    !template->ls_req || !template->fcp_io ||
>   	    !template->ls_abort || !template->fcp_abort ||
>   	    !template->max_hw_queues || !template->max_sgl_segments ||
> -	    !template->max_dif_sgl_segments || !template->dma_boundary ||
> -	    !template->module) {
> +	    !template->max_dif_sgl_segments || !template->dma_boundary) {
>   		ret = -EINVAL;
>   		goto out_reghost_failed;
>   	}
> @@ -2016,7 +2015,6 @@ nvme_fc_ctrl_free(struct kref *ref)
>   {
>   	struct nvme_fc_ctrl *ctrl =
>   		container_of(ref, struct nvme_fc_ctrl, ref);
> -	struct nvme_fc_lport *lport = ctrl->lport;
>   	unsigned long flags;
>   
>   	if (ctrl->ctrl.tagset) {
> @@ -2043,7 +2041,6 @@ nvme_fc_ctrl_free(struct kref *ref)
>   	if (ctrl->ctrl.opts)
>   		nvmf_free_options(ctrl->ctrl.opts);
>   	kfree(ctrl);
> -	module_put(lport->ops->module);
>   }
>   
>   static void
> @@ -3074,15 +3071,10 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
>   		goto out_fail;
>   	}
>   
> -	if (!try_module_get(lport->ops->module)) {
> -		ret = -EUNATCH;
> -		goto out_free_ctrl;
> -	}
> -
>   	idx = ida_simple_get(&nvme_fc_ctrl_cnt, 0, 0, GFP_KERNEL);
>   	if (idx < 0) {
>   		ret = -ENOSPC;
> -		goto out_mod_put;
> +		goto out_free_ctrl;
>   	}
>   
>   	ctrl->ctrl.opts = opts;
> @@ -3232,8 +3224,6 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
>   out_free_ida:
>   	put_device(ctrl->dev);
>   	ida_simple_remove(&nvme_fc_ctrl_cnt, ctrl->cnum);
> -out_mod_put:
> -	module_put(lport->ops->module);
>   out_free_ctrl:
>   	kfree(ctrl);
>   out_fail:
> diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
> index 9861fcea39f6..f69ce66e2d44 100644
> --- a/drivers/nvme/target/fcloop.c
> +++ b/drivers/nvme/target/fcloop.c
> @@ -875,7 +875,6 @@ fcloop_targetport_delete(struct nvmet_fc_target_port *targetport)
>   #define FCLOOP_DMABOUND_4G		0xFFFFFFFF
>   
>   static struct nvme_fc_port_template fctemplate = {
> -	.module			= THIS_MODULE,
>   	.localport_delete	= fcloop_localport_delete,
>   	.remoteport_delete	= fcloop_remoteport_delete,
>   	.create_queue		= fcloop_create_queue,
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index f6c8963c915d..db4a04a207ec 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -1985,8 +1985,6 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
>   
>   /* Declare and initialization an instance of the FC NVME template. */
>   static struct nvme_fc_port_template lpfc_nvme_template = {
> -	.module	= THIS_MODULE,
> -
>   	/* initiator-based functions */
>   	.localport_delete  = lpfc_nvme_localport_delete,
>   	.remoteport_delete = lpfc_nvme_remoteport_delete,
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index bfcd02fdf2b8..941aa53363f5 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -610,7 +610,6 @@ static void qla_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
>   }
>   
>   static struct nvme_fc_port_template qla_nvme_fc_transport = {
> -	.module	= THIS_MODULE,
>   	.localport_delete = qla_nvme_localport_delete,
>   	.remoteport_delete = qla_nvme_remoteport_delete,
>   	.create_queue   = qla_nvme_alloc_queue,
> diff --git a/include/linux/nvme-fc-driver.h b/include/linux/nvme-fc-driver.h
> index 6d0d70f3219c..10f81629b9ce 100644
> --- a/include/linux/nvme-fc-driver.h
> +++ b/include/linux/nvme-fc-driver.h
> @@ -270,8 +270,6 @@ struct nvme_fc_remote_port {
>    *
>    * Host/Initiator Transport Entrypoints/Parameters:
>    *
> - * @module:  The LLDD module using the interface
> - *
>    * @localport_delete:  The LLDD initiates deletion of a localport via
>    *       nvme_fc_deregister_localport(). However, the teardown is
>    *       asynchronous. This routine is called upon the completion of the
> @@ -385,8 +383,6 @@ struct nvme_fc_remote_port {
>    *       Value is Mandatory. Allowed to be zero.
>    */
>   struct nvme_fc_port_template {
> -	struct module	*module;
> -
>   	/* initiator-based functions */
>   	void	(*localport_delete)(struct nvme_fc_local_port *);
>   	void	(*remoteport_delete)(struct nvme_fc_remote_port *);
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
